Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbaCDJzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:55:21 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:36591 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511AbaCDJzQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:55:16 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-6a-5315a302fb31
From: Jingoo Han <jg1.han@samsung.com>
To: "'Lee Jones'" <lee.jones@linaro.org>, "'Denis Carikli'" <denis@eukrea.com>
Cc: "'Bryan Wu'" <cooloney@gmail.com>,
        "=?utf-8?Q?'Eric_B=C3=A9nard'?=" <eric@eukrea.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1393511313-18756-1-git-send-email-denis@eukrea.com>
 <20140227152229.GB24910@lee--X1>
In-reply-to: <20140227152229.GB24910@lee--X1>
Subject: Re: [PATCHv12] video: backlight: gpio-backlight: Add DT support.
Date: Tue, 04 Mar 2014 18:55:13 +0900
Message-id: <000001cf378f$d6cbb880$84632980$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8zz8JpPQ3188pdR1aylJ3LpI2+IADv59Ww
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t8zA12mxaLBBk+mqVoc3TmRyWLeqonM
	FvOPnGO1uPD9DrvF5YWXWC3ufz3KaHF51xw2B3aPGUteMHrsnHWX3ePOtT1sHn1bVjF6fN4k
	F8AaxWWTkpqTWZZapG+XwJVx6vsKtoL/0hVPXik3MLaIdTFyckgImEi0vDjNAmGLSVy4t56t
	i5GLQ0hgGaPE8X+/2WCK9rYdgEpMZ5Toe/2ZBcL5zShxctdHJpAqNgE1iS9fDrN3MXJwiAh4
	SSzbawFSwyywnVFi8uKLjCA1QgLJEluPQKzjFNCVeHNxMZgtLOApcejzWrBtLAKqEree3AOL
	8wrYSuz41cIKYQtK/JgMEucAGqouMWVKLkiYWUBb4sm7C6wgYQmg8KO/uiBhEQEjiRdPd7ND
	lIhI7HvxjhHkHAmBj+wSv04fY4dYJSDxbfIhFoheWYlNB5gh/pWUOLjiBssERolZSBbPQlg8
	C8niWUg2LGBkWcUomlqQXFCclF5kqlecmFtcmpeul5yfu4kRErkTdzDeP2B9iDEZaPtEZinR
	5Hxg5OeVxBsamxlZmJqYGhuZW5qRJqwkzpv+KClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dU
	A+OWz583hv85ti581ofwXJ0JJQm7jtjVaKYf/9rm4vU9KpTb/0/jorZzoau9gw+G9pVHnysN
	mbZipfCTb7fYt898f/du7vf1J6dls3Zal205JZTe/qJv6v/lWzk4pVVs/zlFX1JjXc2Tvb60
	9rNMiKjU1uA1UxkuWPFVVdT4XtZ1Mf7iUcG7iV+JpTgj0VCLuag4EQCnbt8U8gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsVy+t9jQV2mxaLBBlM2KVgc3TmRyWLeqonM
	FvOPnGO1uPD9DrvF5YWXWC3ufz3KaHF51xw2B3aPGUteMHrsnHWX3ePOtT1sHn1bVjF6fN4k
	F8Aa1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0
	h5JCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x49T3FWwF/6UrnrxSbmBs
	Eeti5OSQEDCR2Nt2gA3CFpO4cG89kM3FISQwnVGi7/VnFgjnN6PEyV0fmUCq2ATUJL58Ocze
	xcjBISLgJbFsrwVIDbPAdkaJyYsvMoLUCAkkS2w9cpoFxOYU0JV4c3ExmC0s4Clx6PNasG0s
	AqoSt57cA4vzCthK7PjVwgphC0r8mAwS5wAaqi4xZUouSJhZQFviybsLrCBhCaDwo7+6IGER
	ASOJF093s0OUiEjse/GOcQKj0Cwkg2YhDJqFZNAsJB0LGFlWMYqmFiQXFCel5xrpFSfmFpfm
	pesl5+duYgSnhWfSOxhXNVgcYhTgYFTi4XWYIhIsxJpYVlyZe4hRgoNZSYRXcaFosBBvSmJl
	VWpRfnxRaU5q8SHGZKA3JzJLiSbnA1NWXkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE0hNL
	UrNTUwtSi2C2MHFwSjUw5m11/PaW+659RKbWzf64L4Gy+8/G3va8wJb5XX4Tm/HGvyarsouM
	CtN/mExqmBNwob33y9de/33f7D0f8NUEb7isc+iqruNO7cIb/N5fhM5O3eF+XOZXg8VNwT1r
	Vt87sWJj4suuVd57uZjuJqokWYhv+nCsjKtHrUE4ZJmkyeHrHU2uQRv3KrEUZyQaajEXFScC
	AMRRNvNPAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 28, 2014 12:22 AM, Lee Jones wrote:
> On Thu, 27 Feb 2014, Denis Carikli wrote:
> 
> > Signed-off-by: Denis Carikli <denis@eukrea.com>
> > ---
> > ChangeLog v11-resend->v12:
> > - Moved the Cc from the commit message to the "email patch".
> > - The documentation is now more clear.
> > - The unnecessary default_on variable was removed.
> > - gbl->fbdev was already NULL and didn't need to be re-assigned,
> >   so the re-assignement was removed.
> > - The of_device_id struct and .of_match_table are now guarded
> >   against the driver beeing compiled without CONFIG_OF.
> >
> > ChangeLog v11->v11-resend:
> > - Removed the Cc list because it's only one patch.
> >
> > ChangeLog v10->v11:
> > - Shrinked the Cc list.
> > - Fixed the of_match_table warning.
> >
> > ChangeLog v9->v10:
> > - Only the respective maintainers, or people who responded to the patch
> >   were kept in the Cc.
> > - The unnecessary of_match_ptr in of_match_table was removed.
> >
> > ChangeLog v8->v9:
> > - Added Shawn Guo in the Cc list.
> > - The default-brightness-level is now a boolean default-on property,
> >   the gpio is only touched if the gpio-backlight driver instance probes.
> > - The code and documentation was updated accordingly.
> >
> > ChangeLog v7->v8:
> > - The default-state was renamed to default-brightness-level.
> > - default-brightness-level is now mandatory, like for backlight-pwm,
> >   That way we avoid having to handle the case where it's not set,
> >   which means that we would need not to set the gpio, but still
> >   report a brightness value for sysfs, when not all gpio controllers are
> >   able to read the gpio value.
> > - switched the default-brightness-level to boolean values (0 or 1) instead
> >   of using strings ("on", "off", "keep").
> > - The documentation was updated accordingly.
> > - The example in the documentation now uses the dts gpio defines.
> > - The "backlight: gpio_backlight: Use a default state enum." patch was then
> >   dropped, becuase it is not necessary anymore.
> >
> > ChangeLog v6->v7:
> > - removed a compilation warning with the removal of the useless ret declaration.
> >
> > ChangeLog v5->v6:
> > - The default state handling was reworked:
> >   - it's now called default-state, and looks like the gpio-leds default-state.
> >   - it now has a "keep" option, like for the gpio-leds.
> >   - that "keep" option is the default when the default-state property is not set.
> > - The documentation was updated accordingly.
> >
> > ChangeLog v4->v5:
> > - The default-brightness property now defaults to 0 in the driver.
> > - def_value int becomes a bool.
> > - The check for the gpio validity has been reworked.
> > ---
> >  .../bindings/video/backlight/gpio-backlight.txt    |   16 ++++++
> >  drivers/video/backlight/gpio_backlight.c           |   58 +++++++++++++++++---
> >  2 files changed, 67 insertions(+), 7 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/video/backlight/gpio-backlight.txt
> 
> Patch looks good to me now, I just want to see if Jingoo and/or Bryan
> with to add anything. If they don't respond within the next couple of
> days I'll apply the patch.
> 
> Acked-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> 
> --
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog

