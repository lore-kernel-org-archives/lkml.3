Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3JYNv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:51:26 -0400
Received: from fallback3.mail.ru ([94.100.176.58]:37461 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab3JYNvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:51:25 -0400
From: =?UTF-8?B?ZGJ6?= <divide_by_zero@mail.ru>
To: linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?ZGRjY29udHJvbCBkb2Vzbid0IHdvcmsgb24gdGhlIG5ldyBrZXJuZWw=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [178.172.185.11]
Date: Fri, 25 Oct 2013 17:48:50 +0400
Reply-To: =?UTF-8?B?ZGJ6?= <divide_by_zero@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1382708930.658156307@f345.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9PDpVpX025319

Hi, guys and girls!

I have a strange trouble with ddccontrol that I cannot identify and solve
for about a month, so I hope you'll be able to help me.

So, I'm using LMDE system (http://linuxmint.com/start/debian/). Initially
the kernel was 3.2.32, and ddccontrol worked perfectly with my Philips
232E2SB. I was able to change monitor brightness through ddccontrol
commands and I was really happy :)

Then I upgraded my system to Update Pack 7, and the new kernel became of
version 3.10.5. On new kernel ddccontrol doesn't work anymore, but it still
works on the old one (so this isn't software issue).

I have checked kernel configs - for the old kernel and for the new one.
Both configs are identical at i2c sections. I've tried to use old (3.2.32's
one) config with the new kernel, but there was no success.

To be absolutely sure that the problem isn't in the this specific kernel
version (3.10.5), I've downloaded the latest one (3.11.3) from kernel.org and
tried to use old config on this new kernel, but the issue is still
reproducing...

It would be great if you can give me right direction on this issue, 'cause
I don't know what to do now... I really need new kernel and ability to use
ddccontrol.

P.S. Additional info:
----------------------------
The output of 'i2cdetect -l' on the old kernel (3.2.32):
http://pastebin.com/SqDPcwS9
The same on the new one (3.10.5): http://pastebin.com/YCTmX90m

The output of 'ddccontrol -p' on the old kernel (3.2.32):
http://pastebin.com/QL0fAZVC
The same on the new one (3.10.5): http://pastebin.com/vZ4bALmt

And dmesg outputs for both 3.2.32 and 3.10.5 kernels:
- 3.2.32: http://pastebin.com/7ijujvkA
- 3.10.5: http://pastebin.com/t1wdKrAd

I really need someone's help with ddccontrol. It would be great if you or
someone else who do you know can help me :)

Thank you in advance!ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
