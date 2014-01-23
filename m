Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaAWGeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 01:34:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:2491 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbaAWGeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 01:34:19 -0500
X-IronPort-AV: E=Sophos;i="4.95,704,1384272000"; 
   d="scan'208";a="9446733"
Message-ID: <52E0B87C.6020704@cn.fujitsu.com>
Date: Thu, 23 Jan 2014 14:36:44 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, David Rientjes <rientjes@google.com>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org, zhangyanfei@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] numa, mem-hotplug: Fix stack overflow in numa when seting
 kernel nodes to unhotpluggable.
References: <1390456168-28259-1-git-send-email-tangchen@cn.fujitsu.com> <alpine.DEB.2.02.1401222203330.8088@chino.kir.corp.google.com> <20140123061343.GB15206@redhat.com>
In-Reply-To: <20140123061343.GB15206@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/23 14:32:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/23 14:32:51,
	Serialize complete at 2014/01/23 14:32:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2014 02:13 PM, Dave Jones wrote:
> On Wed, Jan 22, 2014 at 10:06:14PM -0800, David Rientjes wrote:
>   >  On Thu, 23 Jan 2014, Tang Chen wrote:
>   >
......
>   >
>   >  I guess it depends on what Dave's CONFIG_NODES_SHIFT is?
>
> It's 10, because I had MAXSMP set.
>
> So, MAX_NUMNODES = 1<<  10
>
> And the bitmask is made of longs. 1024 of them.
>
> How does this work ?

I have the same config with you.

Would you please try it for me ?  Does it work on your box ?

I cannot reproduce this problem on the latest kernel.
But I can reproduce it on 3.10.

Thanks

>
> 	Dave
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

