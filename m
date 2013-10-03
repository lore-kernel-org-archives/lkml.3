Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab3JCOzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 10:55:43 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:42373 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab3JCOzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 10:55:41 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH 0/2] Add support for Qualcomm's PRNG
Date: Thu,  3 Oct 2013 17:52:33 +0300
Message-Id: <1380811955-18085-1-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds hardware RNG driver wich is used to control the
Qualcomm's PRNG hardware block.
The first patch document the DT bindings needed to sucessfuly probe
the driver and the second patch adds the driver.

Comments are welecome!

Stanimir Varbanov (2):
  ARM: DT: msm: Add Qualcomm's PRNG driver binding document
  hwrng: msm: Add PRNG support for MSM SoC's

 .../devicetree/bindings/rng/qcom,prng.txt          |  17 ++
 drivers/char/hw_random/Kconfig                     |  12 ++
 drivers/char/hw_random/Makefile                    |   1 +
 drivers/char/hw_random/msm-rng.c                   | 211 +++++++++++++++++++++
 4 files changed, 241 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/qcom,prng.txt
 create mode 100644 drivers/char/hw_random/msm-rng.c

-- 
1.8.3.1

