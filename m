Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab3A1LXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:23:25 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:51408 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3A1LXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:23:23 -0500
Message-ID: <51065FA6.4070208@googlemail.com>
Date: Mon, 28 Jan 2013 11:23:18 +0000
From: Chris Clayton <chris2553@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130108 Thunderbird/17.0.2
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>
CC: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        Yijing Wang <wangyijing0307@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: 3.8.0-rc4+ - Oops on removing WinTV-HVR-1400 expresscard TV Tuner
References: <51016937.1020202@googlemail.com> <510189B1.606@fold.natur.cuni.cz> <5104427D.2050002@googlemail.com> <510494D6.1010000@gmail.com> <51050D43.2050703@googlemail.com> <51051B1B.3080105@gmail.com> <51052DB2.4090702@googlemail.com> <51053917.6060400@fold.natur.cuni.cz> <5105491E.9050907@googlemail.com> <510558CE.9000600@fold.natur.cuni.cz> <5105AFDB.9000200@googlemail.com> <5105E51D.2020606@huawei.com> <51064F1A.1020909@googlemail.com>
In-Reply-To: <51064F1A.1020909@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[snip]

> [chris:~]$ cat /proc/cmdline
> root=/dev/sda5 pciehp_ports=native ro resume=/dev/sda6
                      ^^
                   **typo**
I've run the test again with pcie_ports=native and the directories now 
get populated. Even better though, is that when I plug in the card, 
hotplug **works** and the card's drivers are loaded.

Excellent! Thank you so much for your help (and patience) Martin and Yijing.

Now to solving why running scandvb doesn't find any TV channels.

Chris

[snip]
