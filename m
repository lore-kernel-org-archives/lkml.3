Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab3A1MND (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 07:13:03 -0500
Received: from fold.natur.cuni.cz ([195.113.57.32]:37829 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756961Ab3A1MM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 07:12:57 -0500
Message-ID: <51066B46.10409@fold.natur.cuni.cz>
Date: Mon, 28 Jan 2013 13:12:54 +0100
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20100101 Firefox/17.0 SeaMonkey/2.14.1
MIME-Version: 1.0
To: Chris Clayton <chris2553@googlemail.com>
CC: Yijing Wang <wangyijing@huawei.com>,
        Yijing Wang <wangyijing0307@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: 3.8.0-rc4+ - Oops on removing WinTV-HVR-1400 expresscard TV Tuner
References: <51016937.1020202@googlemail.com> <510189B1.606@fold.natur.cuni.cz> <5104427D.2050002@googlemail.com> <510494D6.1010000@gmail.com> <51050D43.2050703@googlemail.com> <51051B1B.3080105@gmail.com> <51052DB2.4090702@googlemail.com> <51053917.6060400@fold.natur.cuni.cz> <5105491E.9050907@googlemail.com> <510558CE.9000600@fold.natur.cuni.cz> <5105AFDB.9000200@googlemail.com> <5105E51D.2020606@huawei.com> <51064F1A.1020909@googlemail.com> <51065FA6.4070208@googlemail.com>
In-Reply-To: <51065FA6.4070208@googlemail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Clayton wrote:
> 
> [snip]
> 
>> [chris:~]$ cat /proc/cmdline
>> root=/dev/sda5 pciehp_ports=native ro resume=/dev/sda6
>                      ^^
>                   **typo**
> I've run the test again with pcie_ports=native and the directories now get populated. Even better though, is that when I plug in the card, hotplug **works** and the card's drivers are loaded.

BTW, I have with acpiphp on 3.7.4:

ls -la /sys/bus/pci_express/devices
total 0
drwxr-xr-x 2 root root 0 Jan 28 13:07 .
drwxr-xr-x 4 root root 0 Jan 28 13:07 ..
$ ls -la /sys/bus/pci/devices/slots
ls: cannot access /sys/bus/pci/devices/slots: No such file or directory
$

And for me hotplug also works (as far as I can tell). ;-)

> 
> Excellent! Thank you so much for your help (and patience) Martin and Yijing.
> 
> Now to solving why running scandvb doesn't find any TV channels.

Would be fine if you could re-do the PresDet checks and confirm whether it is also broken
for you under pciehp.

Martin
