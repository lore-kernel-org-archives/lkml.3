Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab3ALKjl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 05:39:41 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:40062 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3ALKjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 05:39:40 -0500
Message-ID: <50F13D6B.4030703@kernel.org>
Date: Sat, 12 Jan 2013 10:39:39 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alessandro Rubini <rubini@gnudd.com>
CC: christophe.leroy@c-s.fr, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, patrick.vasseur@c-s.fr
Subject: Re: [PATCH] IIO ADC support for AD7923
References: <201301080842.r088gKWO031124@localhost.localdomain> <20130108091414.GA28404@mail.gnudd.com>
In-Reply-To: <20130108091414.GA28404@mail.gnudd.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2013 09:14 AM, Alessandro Rubini wrote:
>> +config AD7923
> 
> I wonder if IIO config symbols should have IIO_ in their name, so
> people looking at config files knows what they actually are.
> Actually, all USB drivers have USB in their config name, which is
> useful even if e.g. "PL2303" cannot be but USB.
> 
> On the other hand, AD7923 and all the others can well be driven by
> something else than IIO, even if currently this is the only mainstream
> option. Here comedi made the right choice, and all their symbols are
> in the CONFIG_COMEDI_ name space.
> 
> Thanks
> /alessandro
I have no particular problem with this for new drivers, but
obviously it is an interface change for older ones that may
cause some issues.  Anyone else care either way?

Various patches to at least kill off missleading config symbol
names (SENSOR_ which is used hwmon) have been kicking around but
I admit I keep putting them on the back burner on the basis there
are better things to be getting on with and it will cause a fair bit
of churn.
