Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab3CFXqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 18:46:06 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:65083 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab3CFXqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 18:46:04 -0500
MIME-Version: 1.0
In-Reply-To: <510A5F0E.6010100@googlemail.com>
References: <51016937.1020202@googlemail.com> <510189B1.606@fold.natur.cuni.cz>
 <5104427D.2050002@googlemail.com> <510494D6.1010000@gmail.com>
 <51050D43.2050703@googlemail.com> <51051B1B.3080105@gmail.com>
 <51052DB2.4090702@googlemail.com> <51053917.6060400@fold.natur.cuni.cz>
 <5105491E.9050907@googlemail.com> <510558CE.9000600@fold.natur.cuni.cz>
 <5105AFDB.9000200@googlemail.com> <5105E51D.2020606@huawei.com>
 <51064F1A.1020909@googlemail.com> <51065FA6.4070208@googlemail.com>
 <51066B46.10409@fold.natur.cuni.cz> <5106CD6C.4070009@googlemail.com>
 <5106E770.9070602@fold.natur.cuni.cz> <510A5F0E.6010100@googlemail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 6 Mar 2013 16:45:43 -0700
Message-ID: <CAErSpo4x8pb7J8MnokXiFTE=01-TffCk6CKC0VS7CEf3X1bSBw@mail.gmail.com>
Subject: Re: 3.8.0-rc4+ - Oops on removing WinTV-HVR-1400 expresscard TV Tuner
To: Chris Clayton <chris2553@googlemail.com>
Cc: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        Yijing Wang <wangyijing@huawei.com>,
        Yijing Wang <wangyijing0307@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 5:09 AM, Chris Clayton <chris2553@googlemail.com> wrote:

> My usb3 expresscard device has arrived and I get an oops with that too, if I
> remove it without unloading the driver first. I guess it shouldn't be a
> surprise that the driver isn't expecting the device to disappear.
>
> As I mentioned, I have some trouble with the WinTV-HVR-1400 card, which
> sometimes pops out again, if I push it into the slot too hard (but I'm
> geeting better at that with practice). So what I've done (with the usb3 card
> too) to avoid the oopsen is blacklist the driver in
> /etc/modprobe.d/blacklist.conf and then load them when I'm sure the card is
> properly inserted. Not exactly hotplug, but at least I don't have to reboot
> because of an oops- and it's not something I'm doing several times an hour.

Hi Chris,

What's the current state of this?  It sounds to me like it still
doesn't work out of the box.  Having to blacklist the driver and load
it manually is a completely unacceptable user experience.  If you have
to manually choose acpiphp over pciehp, that is also unacceptable.

So if you're still limping along with hacky workarounds like this, I'd
like to pursue this more and see if we can't figure out a better
solution.

Bjorn
