Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbaEVPSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:18:35 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:60459 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbaEVPSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:18:32 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, chris@printf.net,
        ulf.hansson@linaro.org
Cc: peter.griffin@linaro.org, kernel@stlinux.com, lee.jones@linaro.org,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Add SDHCI support for STMicroelectronics SoCs
Date: Thu, 22 May 2014 16:18:14 +0100
Message-Id: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds a SDHCI platform driver for ST SoCs, along with
the additional device tree bindings and configuration to enable
the controller to work properly.

Initially it supports the stih416 and stih415 SoCs, and has
been tested on a stih416-b2020 board.

regards,

Peter.

