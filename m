Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932910AbaJVKAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 06:00:49 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:49791 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932374AbaJVKAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 06:00:45 -0400
Message-ID: <1413972056.4214.0.camel@mm-sol.com>
Subject: Re: [PATCH v3] iio: iadc: Qualcomm SPMI PMIC current ADC driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Hartmut Knaack <knaack.h@gmx.de>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jonathan Cameron <jic23@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Fugang Duan <B38611@freescale.com>, Lee Jones <lee.jones@linaro.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Wed, 22 Oct 2014 13:00:56 +0300
In-Reply-To: <544416EF.8080603@gmx.de>
References: <1412180088-24683-1-git-send-email-iivanov@mm-sol.com>
	 <544416EF.8080603@gmx.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.5-fta1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2014-10-19 at 21:54 +0200, Hartmut Knaack wrote:
> Ivan T. Ivanov schrieb am 01.10.2014 18:14:
> >  The current ADC is peripheral of Qualcomm SPMI PMIC chips. It has
> >  16 bits resolution and register space inside PMIC accessible 
> > across
> >  SPMI bus.
> > 
> >  The driver registers itself through IIO interface.
> > 
> Hi, I spotted some issues, see inline.

Thank you. All of them look reasonable. Will fix them and resend.

Regards,
Ivan
