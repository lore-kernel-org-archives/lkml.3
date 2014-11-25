Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbaKYVYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:24:09 -0500
Received: from mail01.mattiasschlenker.de ([5.9.192.132]:40040 "EHLO
	mail01.mattiasschlenker.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751305AbaKYVYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:24:07 -0500
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Nov 2014 16:24:07 EST
Message-ID: <5474F177.9030404@mattiasschlenker.de>
Date: Tue, 25 Nov 2014 22:15:35 +0100
From: Mattias Schlenker <ms@mattiasschlenker.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Cross compile broken - 3.17.3 vs. 3.17.4?
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (mail01.mattiasschlenker.de [0.0.0.0]); Tue, 25 Nov 2014 21:12:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

when cross compiling with a rather generic x86_64-linux-gnu toolchain I 
run into the problem that "make bzImage" fails. It seems vmlinux binary 
gets run through the hosts objdump and not the $(CROSS_COMPILE)objdump 
as it was in 3.17.3.

I am not accustomed enough to kernel build habits to immediately spot 
the change that lead to this failed compile (178 files were changed 
between 3.17.3 and 3.17.4). But if you want, I am gonna provide you with 
a shell script that is able to set up the needed toolchain and succeed 
with 3.17.3 and fail with 3.17.4. Given my current workload this will 
take around 48 hours.

Regards,
Mattias

-- 
Mattias Schlenker - Freier IT-Fachredakteur und -autor
                              redaktion@mattiasschlenker.de
Mattias Schlenker - IT-Consulting, Softwareentwicklung
                             consulting@mattiasschlenker.de

Address__ August-Bebel-Str. 74 - D-04275 LEIPZIG - GERMANY
Call me! (VoIP)__________________________ +49 341 39290767
Call me! (PoTS + Faksimile)______________ +49 341 30393578
Call me if it's urgent! (Mobile)_________ +49 163  6953657
VATIN_________________________________________ DE240998538

Fork me!____________________ https://github.com/mschlenker
Website.__________________ http://www.mattiasschlenker.de/
My books!___________ http://www.arduino-hausautomation.de/
Google+_________ https://www.google.com/+MattiasSchlenker1
Xing_______ https://www.xing.com/profile/Mattias_Schlenker

