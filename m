Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbbA1UOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:14:25 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:36633 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347AbbA1UOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:14:19 -0500
Message-ID: <1422433540.5754.6.camel@mm-sol.com>
Subject: Re: [PATCH v5 0/2]  Initial support for voltage ADC
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Date: Wed, 28 Jan 2015 10:25:40 +0200
In-Reply-To: <1421748922-8933-1-git-send-email-iivanov@mm-sol.com>
References: <1421748922-8933-1-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.7-fta1.2~trusty 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2015-01-20 at 12:15 +0200, Ivan T. Ivanov wrote:
> This type of volatage ADC could be found in Qualcomm's SPMI PMIC's.
> I'm sorry that it took me so long to send the updated version.
> 
> Changes since v4.
> - Addressed review comments from Hartmut Knaack and Jonathan Cameron:
>   Fixed spelling errors in DT description files.
>   Removed unused structure member.
>   Access to hardware during conversion is protected with mutex.
>   Measuring reference points moved at driver probe time.
> 
> Patches are based on current iio/testing branch.

Hi, 

Are there any comments on these patches?

Regards,
Ivan

> 
> v4 could be found here: https://lkml.org/lkml/2014/11/3/425
> 
> Stanimir Varbanov (2):
>   DT: iio: vadc: document dt binding
>   iio: vadc: Qualcomm SPMI PMIC voltage ADC driver
> 
>  .../devicetree/bindings/iio/adc/qcom,spmi-vadc.txt |  129 +++
>  drivers/iio/adc/Kconfig                            |   14 +
>  drivers/iio/adc/Makefile                           |    1 +
>  drivers/iio/adc/qcom-spmi-vadc.c                   | 1016 ++++++++++++++++++++
>  include/dt-bindings/iio/qcom,spmi-vadc.h           |  119 +++
>  5 files changed, 1279 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.txt
>  create mode 100644 drivers/iio/adc/qcom-spmi-vadc.c
>  create mode 100644 include/dt-bindings/iio/qcom,spmi-vadc.h
> 
> --
> 1.9.1
> 
> 
