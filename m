Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbaCEFye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 00:54:34 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:56837 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaCEFyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 00:54:32 -0500
MIME-Version: 1.0
In-Reply-To: <1393622017.4052.5.camel@x220>
References: <1362744373.5994.57.camel@x61.thuisdomein>
	<1392284459.30853.17.camel@x220>
	<CAMk6uBnjEA2eozct6Q_Cm2BCrF-_3gGuNaBmtymGKYpPjoLUVw@mail.gmail.com>
	<1393622017.4052.5.camel@x220>
Date: Wed, 5 Mar 2014 13:54:32 +0800
Message-ID: <CAMk6uBmm8mXqjW6iP+P8rDEY3hN-JpWvohomBeeRTFK4PgcXCw@mail.gmail.com>
Subject: Re: [PATCH] blackfin: bf537: fix typo "CONFIG_SND_SOC_ADV80X_MODULE"
From: Steven Miao <realmz6@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: bfin <adi-buildroot-devel@lists.sourceforge.net>,
        "open list:CAN NETWORK DRIVERS <linux-can@vger.kernel.org>, open" 
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Sat, Mar 1, 2014 at 5:13 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Steven,
>
> On Wed, 2014-02-26 at 18:35 +0800, Steven Miao wrote:
>> On Thu, Feb 13, 2014 at 5:40 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
>> >> 1) There are many lines that might be converted to IS_ENABLED() in this
>> >> file. I'm not sure if and how that should be done.
>> Sorry for the late reply. There are many CONFIG_xxx ||
>> CONFIG_xxx_MODULE things, we need a cleanup for it under all the
>> stamp.c and ezkit.c.
>
> Should I draft a patch to do that? And should that patch include this
> patch, or is this patch finally getting pushed (after some testing, that
> is)?
Yes, sure you can, and I will test your patch.
>
> Thanks,
>
>
> Paul Bolle
>
-steven
