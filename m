Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaJAHsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:48:11 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:63836 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaJAHsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:48:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Aaron Lu <aaron.lu@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 03/15] ACPI: Allow drivers to match using Device Tree compatible property
Date: Wed, 01 Oct 2014 09:48 +0200
Message-ID: <1977503.88D87WA4bh@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <3582127.hCPY12ZqpT@vostro.rjw.lan>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <1852462.V1jlbi8OPt@vostro.rjw.lan> <3582127.hCPY12ZqpT@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:3g88BKJyo/MkNUbedcYpzk3nfEbEjTf36aK6EX6k6ek
 RaMAMvMMCw+/ceU6/y6LqzLlWiJpEKUO/sq2ejyYpWeQg+N76s
 m4XaWwh9zLbPbMHoGnnn8ZMom75O/xKEr46hGunDzYDn/q+i3Y
 n75Er2kBiNH0auFBQ8OnIMo5s304zkBqpm6FARPqYOKrPMVwUI
 ejPBj6EohChLRBUImp8WYhG094FXr5ESCg96q9AZ2cp9gR7OM/
 ykV5HBPIaCLKVwHJ7ypIpdZsvT0djpemWl7dTG/f8Of66LSnd2
 kq8wvhT8paW3O+XyYB0gv5JFlsIZfmtMK8Q+HsARL+7TTttsHc
 F4tdmrNKvuoFRAxzSLh4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2014 04:10:40 Rafael J. Wysocki wrote:
> From: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> We have lots of existing Device Tree enabled drivers and allocating
> separate _HID for each is not feasible. Instead we allocate special _HID
> "PRP0001" that means that the match should be done using Device Tree
> compatible property using driver's .of_match_table instead.
> 
> If there is a need to distinguish from where the device is enumerated
> (DT/ACPI) driver can check dev->of_node or ACPI_COMPATION(dev).
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
