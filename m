Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3AXCeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 21:34:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:2575 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab3AXCeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 21:34:00 -0500
X-IronPort-AV: E=Sophos;i="4.84,526,1355068800"; 
   d="scan'208";a="6637689"
Message-ID: <51009C67.3090809@cn.fujitsu.com>
Date: Thu, 24 Jan 2013 10:28:55 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, Eric Dumazet <erdnetdev@gmail.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH V6 1/3] virtio-net: fix the set affinity bug when CPU
 IDs are not consecutive
References: <1358767524-17934-1-git-send-email-gaowanlong@cn.fujitsu.com> <87hamavx4n.fsf@rustcorp.com.au>
In-Reply-To: <87hamavx4n.fsf@rustcorp.com.au>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/24 10:28:01,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/24 10:33:01,
	Serialize complete at 2013/01/24 10:33:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 09:12 AM, Rusty Russell wrote:
> Wanlong Gao <gaowanlong@cn.fujitsu.com> writes:
> 
>> As Michael mentioned, set affinity and select queue will not work very
>> well when CPU IDs are not consecutive, this can happen with hot unplug.
>> Fix this bug by traversal the online CPUs, and create a per cpu variable
>> to find the mapping from CPU to the preferable virtual-queue.
> 
> This series looks fairly sane at a glance, to me, but MST is the Ack you
> need.

Hi Michael,

Any comments?

Thanks,
Wanlong Gao

> 
> Thanks,
> Rusty.
> 

