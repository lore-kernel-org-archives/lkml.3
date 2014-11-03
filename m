Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbaKCIos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:44:48 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:51836 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbaKCIoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:44:46 -0500
Message-ID: <1415004303.407.11.camel@mm-sol.com>
Subject: Re: [PATCH v4] iio: iadc: Qualcomm SPMI PMIC current ADC driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Peter Meerwald <pmeerw@pmeerw.net>
Cc: Hartmut Knaack <knaack.h@gmx.de>, Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Mon, 03 Nov 2014 10:45:03 +0200
In-Reply-To: <alpine.DEB.2.02.1410312128100.18476@pmeerw.net>
References: <1413987213-22218-1-git-send-email-iivanov@mm-sol.com>
	 <5453ED55.2000003@gmx.de> <alpine.DEB.2.02.1410312128100.18476@pmeerw.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.6-fta3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2014-10-31 at 21:48 +0100, Peter Meerwald wrote:
> > Ivan T. Ivanov schrieb am 22.10.2014 16:13:
> > > The current ADC is peripheral of Qualcomm SPMI PMIC chips. It has
> > > 16 bits resolution and register space inside PMIC accessible across
> > > SPMI bus.
> > >
> > > The driver registers itself through IIO interface.
> > Pretty much there, just one question I would like to double-check: The CPU of these chips is 
> Little Endian, right?
> > Annoyingly, you introduced a small typo in this revision, but that alone doesn't qualify for a 
> new revision. A separate patch fixing it would probably be best. See inline.
> 
> some minor comments below

Thanks, will fix them. IIO maintainers, what do you
prefer, new version or fallow-up patch?

Regards,
Ivan
