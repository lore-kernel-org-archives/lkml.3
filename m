Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaA1Eom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 23:44:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:39868 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753455AbaA1Eol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 23:44:41 -0500
X-IronPort-AV: E=Sophos;i="4.95,733,1384272000"; 
   d="scan'208";a="9460397"
Message-ID: <52E7364F.5010700@cn.fujitsu.com>
Date: Tue, 28 Jan 2014 12:47:11 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, David Rientjes <rientjes@google.com>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org, zhangyanfei@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] numa, mem-hotplug: Fix stack overflow in numa when seting
 kernel nodes to unhotpluggable.
References: <1390456168-28259-1-git-send-email-tangchen@cn.fujitsu.com> <alpine.DEB.2.02.1401222203330.8088@chino.kir.corp.google.com> <alpine.DEB.2.02.1401271631090.17114@chino.kir.corp.google.com> <52E70165.8070709@cn.fujitsu.com> <20140128025537.GA21730@redhat.com> <52E722F5.9010505@cn.fujitsu.com> <20140128035518.GA25386@redhat.com>
In-Reply-To: <20140128035518.GA25386@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/28 12:43:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/28 12:43:05,
	Serialize complete at 2014/01/28 12:43:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 11:55 AM, Dave Jones wrote:
> On Tue, Jan 28, 2014 at 11:24:37AM +0800, Tang Chen wrote:
>
>   >  >  I did a bisect with the patch above applied each step of the way.
>   >  >  This time I got a plausible looking result....
>   >
>   >  I cannot reproduce this. Would you please share how to reproduce it ?
>   >  Or does it just happen during the booting ?
>
> Just during boot. Very early. So early in fact, I have no logging facilities
> like usb-serial, just what is on vga console.
>
> If you want me to add some printk's, I can add a while (1); before
> the part that oopses so we can diagnose further..

Sure. Would you please do that for me ? Maybe we can find something in 
the early log.

Thanks.

>
> 	Dave
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
