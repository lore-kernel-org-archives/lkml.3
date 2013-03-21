Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853Ab3CUHUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 03:20:54 -0400
Received: from forward1.mail.yandex.net ([77.88.46.6]:33096 "EHLO
	forward1.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932584Ab3CUHUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 03:20:52 -0400
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Mar 2013 03:20:52 EDT
Message-ID: <514AB34F.9060707@yandex.ru>
Date: Thu, 21 Mar 2013 13:14:23 +0600
From: Vitaliy Bortsov <bortsov@yandex.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: WCH CH352 PCI-to-RS232 card bad default type
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
According to manufacture chip information from 
http://wch-ic.com/product/pci/ch352.asp type of emulated chip cannot be 
16C550A (it is default value in linux and in patch 
https://lkml.org/lkml/2013/3/2/30 ). Correct value is 16550.
Therefore I need to run additional command
setserial /dev/ttySx uart 16550

Default value 16550A is not working, correct value 16550 is working on 
my PCI-RS232card.

Please somebody make changes to module 
drivers/tty/serial/8250/8250_pci.c (as I think).

Regards,
   Vitaliy
