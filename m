Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbaJ1BM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 21:12:29 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:47099 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbaJ1BM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 21:12:27 -0400
MIME-Version: 1.0
In-Reply-To: <544EDD40.1040107@gaast.net>
References: <543F049F.5090605@gaast.net>
	<CAE9FiQWDHq5esSt4UvE5AkHR-=XMvrzaNFwLg+0xKisTNOtcsQ@mail.gmail.com>
	<543F9182.9000004@gaast.net>
	<CAE9FiQVNZHTxpNCnn+YPtqjWrQjFmtTh06sbBawqFonMFwSZ-w@mail.gmail.com>
	<544033CF.3080104@gaast.net>
	<CAE9FiQW0x5uy_osjvVDOOMDaz2=2KL+TusQ8QqcHL5dWTPrK2w@mail.gmail.com>
	<5442FE58.5020700@gaast.net>
	<CAE9FiQWugqXZdZDhDyKofKRXH6EgVq6DJ0JphM6DZSdS5nMhbw@mail.gmail.com>
	<5446D2D8.2090203@gaast.net>
	<CAE9FiQWjvZapL0u5QSwD3gYTXisKrCgRcUYWAcy8onUYbkLHTg@mail.gmail.com>
	<20141022125354.GA3832@gaast.net>
	<CAE9FiQXF-6b4+y-BJmv7ekrCrXKYyhvZDBqVbLeXSPJa0_cToA@mail.gmail.com>
	<544E235C.5010908@gaast.net>
	<CAE9FiQVMaGs=2OMbk6M7x=EhhfaVn5xT_70Sr+rU2Z1HEfjXbw@mail.gmail.com>
	<544EC59D.9080303@gaast.net>
	<CAE9FiQXC7YfzPp43EX5r4KNPhF4jua_Jg_JLBnSTffzAmRaY=g@mail.gmail.com>
	<544EDD40.1040107@gaast.net>
Date: Mon, 27 Oct 2014 18:12:26 -0700
X-Google-Sender-Auth: quAe7tWVIz-jGCrFts-tqjAUzYg
Message-ID: <CAE9FiQWfV+h5YGxKEg7kSdhD7_OVoEqNyZZqYr=vpDwz1Lnb_g@mail.gmail.com>
Subject: Re: Machine crashes right *after* ~successful resume
From: Yinghai Lu <yinghai@kernel.org>
To: Wilmer van der Gaast <wilmer@gaast.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 5:03 PM, Wilmer van der Gaast <wilmer@gaast.net> wrote:
> I was curious about that already, did that with a 3.16.6 that I think just
> had your revert applied (and using lspci -xxxx to get the dump which I
> assumed would be the same): No changes to 04:00 at all.
>
> Confirmed that this is the case with 3.17 + those patches as well, it's
> showing this at all times:

can you post
lspci -vvxxxx -s 00:1c.3
lspci -vvxxxx -s 04:00.0
before reverting enable bridge early patch
and after reverting on 3.17+?

Thanks

Yinghai
