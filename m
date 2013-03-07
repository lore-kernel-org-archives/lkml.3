Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab3CGA3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:29:55 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5307 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab3CGA3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:29:52 -0500
X-IronPort-AV: E=Sophos;i="4.84,798,1355126400"; 
   d="scan'208";a="27740510"
From: David Brown <davidb@codeaurora.org>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org
Subject: [PATCH 0/6] Qualcomm SSBI bus driver
Date: Wed,  6 Mar 2013 16:29:41 -0800
Message-Id: <1362616187-21089-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small series adds the Qualcomm SSBI bus driver.  The original
driver was developed as part of Android.  Kenneth Heitke updated this,
and sent it out a while back.  This series updates this driver to use
DeviceTree, and fixes a few things that have changed since it was
originally sent out.

In addition, the 6th patch, the RFC, is a small test driver that reads
the version register off of the pm8058 device typically connected to
an MSM8660 or MSM8960.  This is primarily useful to anyone wanting to
work on these pmic drivers.

Updates to the PMIC drivers themselves to use this driver to come.

David
