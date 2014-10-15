Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbaJOPLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 11:11:30 -0400
Received: from twosheds.infradead.org ([90.155.92.209]:45238 "EHLO
	twosheds.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaJOPL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 11:11:28 -0400
X-Greylist: delayed 3787 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Oct 2014 11:11:27 EDT
Message-ID: <7ce75234f8b2dd8bcc747f296f626487.squirrel@twosheds.infradead.org>
In-Reply-To: <543E88CF.5060504@linux.intel.com>
References: <2660541.BycO7TFnA2@vostro.rjw.lan>
    <1413378271.2762.77.camel@infradead.org>
    <20141015131551.GC20034@leverpostej>
    <1413379736.2762.79.camel@infradead.org>
    <20141015134209.GD20034@leverpostej>
    <db4038336b5e165b8b61eda064b10eeb.squirrel@twosheds.infradead.org>
    <543E88CF.5060504@linux.intel.com>
Date: Wed, 15 Oct 2014 15:11:18 -0000
Subject: Re: [PATCH v4 00/13] Add ACPI _DSD and unified device properties
 support
From: "David Woodhouse" <dwmw2@infradead.org>
To: "Darren Hart" <dvhart@linux.intel.com>
Cc: "David Woodhouse" <dwmw2@infradead.org>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Mika Westerberg" <mika.westerberg@linux.intel.com>,
        "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>,
        "Aaron Lu" <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        "Alexandre Courbot" <gnurou@gmail.com>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "Bryan Wu" <cooloney@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "Arnd Bergmann" <arnd@arndb.de>, dvhart@infradead.org
User-Agent: SquirrelMail/1.4.22-14.fc20
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by twosheds.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> My comment was going to be along the same lines. It is an optional
> parameter, which is what I would expect for a firmware-specific type of
> property.

Right. Fundamentally, device properties (in DT or ACPI) exist to describe
the hardware in a generic and abstract fashion. It's a slippery slope from
saying "you don't need this property because you know you whether you are
on the *foo* architecture", to saying "you don't this property because you
know whether you're on a Assabet or not." I think it's wrong to go down
that path.

-- 
dwmw2

