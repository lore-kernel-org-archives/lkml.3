Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab3GASs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 14:48:59 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:46072 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802Ab3GASs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 14:48:58 -0400
X-Greylist: delayed 473 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Jul 2013 14:48:57 EDT
Message-ID: <51D1CD3B.80804@free.fr>
Date: Mon, 01 Jul 2013 20:40:59 +0200
From: Eric Valette <eric.valette@free.fr>
Reply-To: eric.valette@free.fr
Organization: HOME
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: memmap exclude boot command: how to check if it was indeed applied
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After  hunting an unreproducible bug, I decided to run memtest86+ and 
found that only 8 byte of memory refuse to write the last two digit on 
the last 4GB memory stick.

Memory is at 0x31db357558

So I decided to add a memmap=4K@0x000000031db35000 boot options in 
GRUB_CMDLINE_LINUX. But checking dmesg, I see no mention of this page 
being reserved.

PS: CC me I'm not subscribed.

-- eric
