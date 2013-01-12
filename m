Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab3ALRNL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 12:13:11 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:35030 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752126Ab3ALRNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 12:13:09 -0500
Message-ID: <50F199F7.7020600@metafoo.de>
Date: Sat, 12 Jan 2013 18:14:31 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11
MIME-Version: 1.0
To: Alessandro Rubini <rubini@gnudd.com>
CC: christophe.leroy@c-s.fr, jic23@cam.ac.uk, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, patrick.vasseur@c-s.fr
Subject: Re: [PATCH] IIO ADC support for AD7923
References: <201301080842.r088gKWO031124@localhost.localdomain> <20130108091414.GA28404@mail.gnudd.com>
In-Reply-To: <20130108091414.GA28404@mail.gnudd.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2013 10:14 AM, Alessandro Rubini wrote:
>> +config AD7923
> 
> I wonder if IIO config symbols should have IIO_ in their name, so
> people looking at config files knows what they actually are.
> Actually, all USB drivers have USB in their config name, which is
> useful even if e.g. "PL2303" cannot be but USB.
> 
> On the other hand, AD7923 and all the others can well be driven by
> something else than IIO, even if currently this is the only mainstream
> option.

No, IIO is and should be the only option for these devices. We really don't
want to drivers for the same device in different subsystems of the kernel.

The other argument is still valid though.

> Here comedi made the right choice, and all their symbols are
> in the CONFIG_COMEDI_ name space.

- lars
