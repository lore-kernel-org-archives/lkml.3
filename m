Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab3BDNTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:19:06 -0500
Received: from 8bytes.org ([85.214.48.195]:33804 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213Ab3BDNTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:19:03 -0500
From: Joerg Roedel <joro@8bytes.org>
To: Sethi Varun-B16395 <B16395@freescale.com>, Stuart Yoder <b08248@gmail.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5 v2] iommu: Support non-paging IOMMUs
Date: Mon,  4 Feb 2013 14:18:38 +0100
Message-Id: <1359983924-28952-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Feb  4 14:19:01 2013
X-DSPAM-Confidence: 0.9980
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 510fb54522971409417442
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Varuns, Stuart,

here is the reworked patch-set with the IOMMU-API changes to support the
PAMU IOMMU. It should include the results from our discussion last week.
Please have a look at it and tell me if this interface works for you. I
will merge it then into the IOMMU tree so that you have a branch to base
the PAMU patches on.

Thanks,

	Joerg


