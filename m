Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbaJaVWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 17:22:13 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:47336 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaJaVWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 17:22:11 -0400
MIME-Version: 1.0
In-Reply-To: <5453FB8E.8050506@gaast.net>
References: <543F049F.5090605@gaast.net>
	<544E235C.5010908@gaast.net>
	<CAE9FiQVMaGs=2OMbk6M7x=EhhfaVn5xT_70Sr+rU2Z1HEfjXbw@mail.gmail.com>
	<544EC59D.9080303@gaast.net>
	<CAE9FiQXC7YfzPp43EX5r4KNPhF4jua_Jg_JLBnSTffzAmRaY=g@mail.gmail.com>
	<544EDD40.1040107@gaast.net>
	<CAE9FiQWfV+h5YGxKEg7kSdhD7_OVoEqNyZZqYr=vpDwz1Lnb_g@mail.gmail.com>
	<545027F9.1040703@gaast.net>
	<CAE9FiQXM=uAWPD04o8ic2juEaWVQ=seq=+CBjnPnFdrueY-RjQ@mail.gmail.com>
	<5450B55E.6010103@gaast.net>
	<CAE9FiQUH_Ce4ejnn_GG=QnG=R3jt7jHzYScPy-hqPzBMbFU=EQ@mail.gmail.com>
	<545214C5.6070004@gaast.net>
	<CAE9FiQVZV8xk0haCPo=nikBCNQfawPiw20kdEUGfJ_NdtSi5JQ@mail.gmail.com>
	<5452B3A6.7060100@gaast.net>
	<CAE9FiQUGm-gvqpzPymxqa6vdfV7xhv8-fb433irZE1AT-eNg9A@mail.gmail.com>
	<5452C8BE.3060206@gaast.net>
	<CAE9FiQWd7wC9ijzgObCcGd9QE+U3_wzjQwafXhV=U61hLxGszg@mail.gmail.com>
	<CAE9FiQXPZdYndp6rTKxLUkkwX=AQtRVH3JJC=xzQfsehtBgOqA@mail.gmail.com>
	<545358D5.6070903@gaast.net>
	<CAE9FiQWeZ4AXwwT=NS96Q+FxPz+3Bj5rf8JoRDmJ-RHBhjj78g@mail.gmail.com>
	<5453FB8E.8050506@gaast.net>
Date: Fri, 31 Oct 2014 14:22:10 -0700
X-Google-Sender-Auth: Ti-kXe5KgtRjmACTrZ6rZQkAQj8
Message-ID: <CAE9FiQX7nhBKBGUm6SkWdA3EUm1MZ3rgWf04+AUPAPgSCNam=w@mail.gmail.com>
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

On Fri, Oct 31, 2014 at 2:13 PM, Wilmer van der Gaast <wilmer@gaast.net> wrote:
> On 31-10-14 16:11, Yinghai Lu wrote:
>>
>>
>> Good. Please check if attached one on top of 3.17 only would work too.
>>
> No luck, sadly. :-( Unsuccessful third resume.
>
> I forgot to set up the serial console, would that still be useful?

never mind, let me go through suspend/resume code path again.
