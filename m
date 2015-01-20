Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbbATKPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:15:25 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:60570 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbbATKPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:15:20 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH v5 0/2]  Initial support for voltage ADC
Date: Tue, 20 Jan 2015 12:15:20 +0200
Message-Id: <1421748922-8933-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This type of volatage ADC could be found in Qualcomm's SPMI PMIC's.
I'm sorry that it took me so long to send the updated version.

Changes since v4.
- Addressed review comments from Hartmut Knaack and Jonathan Cameron:
  Fixed spelling errors in DT description files.
  Removed unused structure member.
  Access to hardware during conversion is protected with mutex.
  Measuring reference points moved at driver probe time.

Patches are based on current iio/testing branch.

v4 could be found here: https://lkml.org/lkml/2014/11/3/425

Stanimir Varbanov (2):
  DT: iio: vadc: document dt binding
  iio: vadc: Qualcomm SPMI PMIC voltage ADC driver

 .../devicetree/bindings/iio/adc/qcom,spmi-vadc.txt |  129 +++
 drivers/iio/adc/Kconfig                            |   14 +
 drivers/iio/adc/Makefile                           |    1 +
 drivers/iio/adc/qcom-spmi-vadc.c                   | 1016 ++++++++++++++++++++
 include/dt-bindings/iio/qcom,spmi-vadc.h           |  119 +++
 5 files changed, 1279 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.txt
 create mode 100644 drivers/iio/adc/qcom-spmi-vadc.c
 create mode 100644 include/dt-bindings/iio/qcom,spmi-vadc.h

--
1.9.1

