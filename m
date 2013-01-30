Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab3A3VoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 16:44:01 -0500
Received: from 8bytes.org ([85.214.48.195]:56851 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804Ab3A3Vn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 16:43:57 -0500
From: Joerg Roedel <joro@8bytes.org>
To: Sethi Varun-B16395 <B16395@freescale.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] iommu: Support non-paging IOMMUs
Date: Wed, 30 Jan 2013 22:43:44 +0100
Message-Id: <1359582228-21552-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Jan 30 22:43:55 2013
X-DSPAM-Confidence: 0.9981
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5109941b22971342416861
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Varun,

here is a patch-set that implements (what I think are) the necessary
IOMMU-API extensions to support the PAMU. Please have a look at it and
tell me if it fits your needs.


Regards,

	Joerg


