Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab3K3J63 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 04:58:29 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:57714 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab3K3J60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 04:58:26 -0500
Message-ID: <6662B6F95D1C4783A007CAC82A8DA641@ivogl>
From: Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: <gregkh@linuxfoundation.org>
Cc: =?koi8-r?B?6dfByszPIOTJzcnU0s/X?= <freemangordon@abv.bg>,
        <pali.rohar@gmail.com>, <sre@ring0.de>, <pavel@ucw.cz>,
        <omar.ramirez@copitl.com>, <tony@atomide.com>,
        <felipe.contreras@gmail.com>, <s-anna@ti.com>, <nm@ti.com>,
        <ohad@wizery.com>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Staging: tidspbridge: disable driver
Date: Sat, 30 Nov 2013 11:58:23 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="koi8-r";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(re-sending in plain text, sorry for the noise)

commit 
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=930ba4a374b96560ef9fde2145cdc454a164ddcc
disables tidspbridge driver for the reasons it has a security bug and there 
is no active maintainer.
I was following the development of that driver for a bit and my impression 
was that the reason it is
still in staging is this 
http://www.spinics.net/lists/linux-omap/msg84115.html . And as dmtimer
driver is on its way to be merged upstream(or was it already merged?)  I was 
planning to work on
tidspbridge driver to fix it and send the patches. I also have a couple of 
another small patches
ready to be send.

However, could you elaborate on the "security bug" so I can try to fix it 
and send the patch?
Also, what needs to be done for the tidspdriver to get out of staging as it 
seems that what I
though initially is incorrect.

Regards,
Ivo

PS: my further mails will be from this account on gmal as it seems LKML does 
not like
my abv.bg account (freemangordon at abv dot bg) 

