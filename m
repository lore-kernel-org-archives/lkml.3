Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab3HPWKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:10:06 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52949 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3HPWKD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:10:03 -0400
Subject: Re: [PATCH RFC 1/3] spmi: Linux driver framework for SPMI
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <02deef1d90121011ab1df90ad704ef0ee36e2584.1376596224.git.joshc@codeaurora.org>
Date: Fri, 16 Aug 2013 14:04:22 -0500
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Gilad Avidov <gavidov@codeaurora.org>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        Michael Bohan <mbohan@codeaurora.org>,
        Sagar Dharia <sdharia@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <1E157BCF-C34F-4839-AFE0-CBECA828B221@codeaurora.org>
References: <cover.1376596224.git.joshc@codeaurora.org> <02deef1d90121011ab1df90ad704ef0ee36e2584.1376596224.git.joshc@codeaurora.org>
To: Josh Cartwright <joshc@codeaurora.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 9, 2013, at 3:37 PM, Josh Cartwright wrote:

> From: Kenneth Heitke <kheitke@codeaurora.org>
> 
> System Power Management Interface (SPMI) is a specification
> developed by the MIPI (Mobile Industry Process Interface) Alliance
> optimized for the real time control of Power Management ICs (PMIC).
> 
> SPMI is a two-wire serial interface that supports up to 4 master
> devices and up to 16 logical slaves.
> 
> The framework supports message APIs, multiple busses (1 controller
> per bus) and multiple clients/slave devices per controller.
> 
> Signed-off-by: Kenneth Heitke <kheitke@codeaurora.org>
> Signed-off-by: Michael Bohan <mbohan@codeaurora.org>
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
> drivers/Kconfig                 |   2 +
> drivers/Makefile                |   1 +
> drivers/of/Kconfig              |   6 +
> drivers/of/Makefile             |   1 +
> drivers/of/of_spmi.c            |  74 +++++
> drivers/spmi/Kconfig            |   9 +
> drivers/spmi/Makefile           |   7 +
> drivers/spmi/spmi-dbgfs.c       | 591 ++++++++++++++++++++++++++++++++++++++++
> drivers/spmi/spmi-dbgfs.h       |  37 +++
> drivers/spmi/spmi.c             | 449 ++++++++++++++++++++++++++++++
> include/linux/mod_devicetable.h |   8 +
> include/linux/of_spmi.h         |  37 +++
> include/linux/spmi.h            | 337 +++++++++++++++++++++++
> 13 files changed, 1559 insertions(+)
> create mode 100644 drivers/of/of_spmi.c
> create mode 100644 drivers/spmi/Kconfig
> create mode 100644 drivers/spmi/Makefile
> create mode 100644 drivers/spmi/spmi-dbgfs.c
> create mode 100644 drivers/spmi/spmi-dbgfs.h
> create mode 100644 drivers/spmi/spmi.c
> create mode 100644 include/linux/of_spmi.h
> create mode 100644 include/linux/spmi.h

Looks like you are missing a patch for the general OF binding for SPMI

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

