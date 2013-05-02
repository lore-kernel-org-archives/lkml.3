Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761968Ab3EBUeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 16:34:07 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:59871 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330Ab3EBUeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 16:34:05 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:fd44:800e:750b:b0f7:29af]
In-Reply-To: <201305022103.58445.arnd@arndb.de>
References: <alpine.DEB.2.02.1304301707290.5398@kaball.uk.xensource.com>
	<alpine.DEB.2.02.1305021938170.5398@kaball.uk.xensource.com>
	<20130502184801.GF14496@n2100.arm.linux.org.uk>
	<201305022103.58445.arnd@arndb.de>
Date: Thu, 2 May 2013 13:34:03 -0700
Message-ID: <CAOesGMgtwb5z-LcJNf7Jtnz92T7u3Z9_uzBxYCaD1ahwYa514A@mail.gmail.com>
Subject: Re: [PATCH v10 0/2] (arm-soc for v3.10) arm: introduce psci_smp_ops
From: Olof Johansson <olof@lixom.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Will Deacon <will.deacon@arm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 2, 2013 at 12:03 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 02 May 2013, Russell King - ARM Linux wrote:
>> The only issue that there is is where we are in the development cycle
>> (almost mid merge window), and I've yet to push anything to Linus thanks
>> to late discovery of various messups in other chunks of code submitted
>> via my tree - I'm starting to drop stuff from my tree in the hope that
>> I'll get back to something that's going to be suitable for mainline.
>>
>> I really don't want to go pulling anything else at the moment in the
>> hope of getting what I currently have out the door.
>>
>> And in any case, we shouldn't be adding any new code to our trees at
>> this point in time.
>
> Agreed. I would have like to see the patches in 3.10, but the timing
> didn't work out.
>
> Stefano, I'm sure we can queue it up early for 3.11 if you send them
> again after the merge window. Sorry you had to go through 10 versions
> and not getting it merged in time in the end.

Yeah, sorry for being quiet on this; I've seen the patches go by but
also haven't looked closely at them since timing was pointing more
towards 3.11 material. 3.10 is already a very busy release for us on
arm-soc.

If there's SoC code that needs this as a base, we can do a shared
branch with Russell. That has worked well in the past -- he merges it
but we bring in a copy of the topic in our tree.


-Olof
