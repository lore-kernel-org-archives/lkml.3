Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbaHGTE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 15:04:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52243 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaHGTE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 15:04:57 -0400
Date: Thu, 07 Aug 2014 12:04:54 -0700 (PDT)
Message-Id: <20140807.120454.1646328149054855088.davem@davemloft.net>
To: paul@paul-moore.com
Cc: geert@linux-m68k.org, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sel_netif_init: 'err' is used uninitialized
From: David Miller <davem@davemloft.net>
In-Reply-To: <5750080.46d2jsPKXX@sifl>
References: <CAMuHMdV4VpaH1nHYO5hr66Xib5o_Pib863JzGRtg2kYcjMp2TQ@mail.gmail.com>
	<5750080.46d2jsPKXX@sifl>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Aug 2014 12:04:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s77J53nj019771

From: Paul Moore <paul@paul-moore.com>
Date: Thu, 07 Aug 2014 10:26:14 -0400

> On Thursday, August 07, 2014 12:31:15 PM Geert Uytterhoeven wrote:
>> 
>> security/selinux/netif.c: In function ¡sel_netif_init¢:
>> /scratch/geert/linux/linux-m68k/security/selinux/netif.c:285: warning:
>> ¡err¢ is used uninitialized in this function
>> 
>> Should it just return 0, like before?
>> Or should it return the return value of register_netdevice_notifier()
>> instead, which also returns an error code? Or is that failure non-critical?
> 
> Hi,
> 
> I posted a fix for this two days ago to the SELinux list (see below).  As soon 
> as -rc1 is released and linux-next is back in business I'll be pushing the 
> patch to the SELinux #next branch.
> 
>  * http://marc.info/?l=selinux&m=140727033030054&w=2

With respect to this and the lack-of-inline warning fix we spoke about
yesterday, why are you waiting and only pushing such bug fixes into your
"next" branch?

Those sort of things should be sent to Linus now to correct the errors
introduced during the merge window, as I have done last night for all
of the networking merge fallout.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
