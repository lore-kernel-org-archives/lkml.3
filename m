Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631Ab3HHBgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 21:36:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:8790 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932245Ab3HHBgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 21:36:18 -0400
X-IronPort-AV: E=Sophos;i="4.89,836,1367942400"; 
   d="scan'208";a="8149139"
Message-ID: <5202F65F.40002@cn.fujitsu.com>
Date: Thu, 08 Aug 2013 09:37:35 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Rui Xiang <rui.xiang@huawei.com>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, serge.hallyn@ubuntu.com,
        akpm@linux-foundation.org, guz.fnst@cn.fujitsu.com,
        libo.chen@huawei.com
Subject: Re: [PATCH v3 00/11] Add namespace support for syslog
References: <1375861035-24320-1-git-send-email-rui.xiang@huawei.com> <878v0evssv.fsf@xmission.com>
In-Reply-To: <878v0evssv.fsf@xmission.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/08 09:34:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/08 09:34:52,
	Serialize complete at 2013/08/08 09:34:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 03:55 PM, Eric W. Biederman wrote:
> 
> Since this still has not been addressed.  I am going to repeat Andrews
> objection again.
> 
> Isn't there a better way to get iptables information out than to use
> syslog.  I did not have time to follow up on that but it did appear that
> someone did have a better way to get the information out.
> 
> Essentially the argument against this goes.  The kernel logging facility
> is really not a particularly good tool to be using for anything other
> than kernel debugging information, and there appear to be no substantial
> uses for a separate syslog that should not be done in other ways.

containerizing syslog is not only for iptables, it also isolates the /dev/kmsg,
/proc/kmsg, syslog(2)... user space tools in container may use this interface
to read/generate syslog.

But I don't know how important/urgent this containerizing syslog work is,
Rui Xiang, can you find an important/popular user space tool which uses this
interfaces to generate kernel syslog?

Thanks
Gao
