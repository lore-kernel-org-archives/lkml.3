Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab3JXAlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 20:41:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:41958 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab3JXAlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 20:41:19 -0400
X-IronPort-AV: E=Sophos;i="4.93,557,1378828800"; 
   d="scan'208";a="8843807"
Message-ID: <52686CF1.1040300@cn.fujitsu.com>
Date: Thu, 24 Oct 2013 08:42:25 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Guy Briggs <rgb@redhat.com>
CC: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] audit: change pid to portid for audit_reply
References: <1382527523-22505-1-git-send-email-gaofeng@cn.fujitsu.com> <20131023192001.GB5059@madcap2.tricolour.ca>
In-Reply-To: <20131023192001.GB5059@madcap2.tricolour.ca>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 08:38:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 08:38:45,
	Serialize complete at 2013/10/24 08:38:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2013 03:20 AM, Richard Guy Briggs wrote:
> On Wed, Oct 23, 2013 at 07:25:23PM +0800, Gao feng wrote:
>> The "pid" is not a suitable name for netlink port,
>> change it to "portid".
> 
> That is already in the works:
> 	https://www.redhat.com/archives/linux-audit/2013-August/msg00023.html
> 	https://lkml.org/lkml/2013/8/20/630
> 
> May I add your Signed-off-by: to that previous patch?

Oops, I didn't notice that. you can add my Signed-off-by if you wish :)

Thanks
