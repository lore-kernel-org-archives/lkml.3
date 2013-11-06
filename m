Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab3KFNLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:11:52 -0500
Received: from mx0.aculab.com ([213.249.233.131]:52077 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756313Ab3KFNLu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:11:50 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v3 1/3] phy: Add new Exynos USB PHY driver
Date: Wed, 6 Nov 2013 13:03:45 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B73E7@saturn3.aculab.com>
In-Reply-To: <2413995.ezl3Ca2YTh@amdc1227>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v3 1/3] phy: Add new Exynos USB PHY driver
Thread-Index: Ac7a78P5/Fh63gzNQeOXkNtzKVhMVgAAGq9A
References: <1383668001-19141-1-git-send-email-k.debski@samsung.com> <2656549.jVSier62Qi@amdc1227> <527A3B1C.50200@ti.com> <2413995.ezl3Ca2YTh@amdc1227>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Tomasz Figa" <t.figa@samsung.com>,
        "Kishon Vijay Abraham I" <kishon@ti.com>
Cc: "Kamil Debski" <k.debski@samsung.com>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm@vger.kernel.org>,
        <kyungmin.park@samsung.com>, <s.nawrocki@samsung.com>,
        <m.szyprowski@samsung.com>, <gautam.vivek@samsung.com>,
        <mat.krawczuk@gmail.com>, <yulgon.kim@samsung.com>,
        <p.paneri@samsung.com>, <av.tikhomirov@samsung.com>,
        <jg1.han@samsung.com>, <galak@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I just did a diff of registers in exynos 4210 and 4212 PHY drivers [1]
> > and couldn't find that big a difference in register layout. Of course
> > there are a few changes in HSIC bit fields and PHYFSEL but that's only
> > minimal and could well be handled in a single driver.
> >
> > [1] -> http://diffchecker.com/py3tp68m
> 
> This is quite a lot of differences, especially including shifted
> bitfields... In addition there is another set of available PHYs
> and inter-dependencies between them.

Might be worth feeding both files through "sed -e 's/_421[02]_/_421x_/'"
prior to doing the diff.
And maybe changing the order of some definitions so they match.
Then the actual differences will be more obvious.

	David



