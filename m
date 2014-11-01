Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759134AbaKAQjM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 12:39:12 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:56221 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbaKAQjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 12:39:09 -0400
Message-ID: <1414859945.2207.1.camel@mm-sol.com>
Subject: Re: [PATCH v4] iio: iadc: Qualcomm SPMI PMIC current ADC driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Hartmut Knaack <knaack.h@gmx.de>
Cc: Jonathan Cameron <jic23@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-iio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Sat, 01 Nov 2014 18:39:05 +0200
In-Reply-To: <5453ED55.2000003@gmx.de>
References: <1413987213-22218-1-git-send-email-iivanov@mm-sol.com>
	 <5453ED55.2000003@gmx.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.8 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2014-10-31 at 21:13 +0100, Hartmut Knaack wrote:
> Ivan T. Ivanov schrieb am 22.10.2014 16:13:
> > The current ADC is peripheral of Qualcomm SPMI PMIC chips. It has
> > 16 bits resolution and register space inside PMIC accessible across
> > SPMI bus.
> > 
> > The driver registers itself through IIO interface.
> Pretty much there, just one question I would like to double-check: 
> The CPU of these chips is Little Endian, right?

Yes, it is Little Endian.

> Annoyingly, you introduced a small typo in this revision, 

No it is not a typo. Calculation is really in nano Ohms.

Regards,
Ivan
