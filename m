Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbaJAIOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 04:14:06 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:49186 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaJAIOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 04:14:01 -0400
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
Subject: Re: [PATCH v3 11/15] input: gpio_keys_polled - Add support for GPIO descriptors
Date: Wed, 01 Oct 2014 10:13:50 +0200
Message-ID: <2914449.Ivz3LXP1xp@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <24790352.cekkkbNf7i@vostro.rjw.lan>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <1852462.V1jlbi8OPt@vostro.rjw.lan> <24790352.cekkkbNf7i@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:3yNByCJx/dlyiTRtqJLnwmb1mJBObyfJuUzxXZ4rtNd
 g4gsKzGCODepIHeNBfY1e+cbXXwrTBGI8ZjJG5pqnK+86wGFBo
 of4JAY65Be/OI1/Tv25EBe3VIGXKJ/TYPoah0ZFjd4cRYXhKqE
 T4TRztCAjoRm2+5YvnYnwliiLNVQ3oIJeHb21GUjNL/X4M2qcQ
 XEqmPsAM2mRNI2jIKU6kM5NxK2yIYUG7mDrnGsIHmsD7DIZ/5c
 oxqDCDVuuyjvegGDWYF0XP6bIkiR/GWoAZ3RBGEC2trf16vGWc
 9Q/qm7iikZvFO4GqT6tdZaV/fLmRLq0VkBfH63EICJ/IzO5hYn
 6v8TGC3Td5KZKCMyHwm4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2014 04:17:46 Rafael J. Wysocki wrote:
> From: Aaron Lu <aaron.lu@intel.com>
> 
> GPIO descriptors are the preferred way over legacy GPIO numbers
> nowadays. Convert the driver to use GPIO descriptors internally but
> still allow passing legacy GPIO numbers from platform data to support
> existing platforms.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Acked-by: Alexandre Courbot <acourbot@nvidia.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
