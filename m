Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaG3WOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 18:14:36 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:38319 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaG3WOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 18:14:33 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Brian King <brking@linux.vnet.ibm.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] scsi: ibmvscsi: ibmvfc.c:  Cleaning up missing null-terminate in conjunction with strncpy 
Date: Thu, 31 Jul 2014 00:15:58 +0200
Message-Id: <1406758559-20836-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And as I understand it, it is fine to replace strncpy to strlcpy here.
But if any of this code do not want a null terminated, or want to have the whole rest of size filled with null characters. 
If that is the case this is not a good patch.

Rickard Strandqvist (1):
  scsi: ibmvscsi: ibmvfc.c:  Cleaning up missing null-terminate in conjunction with
    strncpy

 drivers/scsi/ibmvscsi/ibmvfc.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

-- 
1.7.10.4

