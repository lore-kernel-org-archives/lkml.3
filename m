Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab3A2B7D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:59:03 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:52653 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751483Ab3A2B7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:59:02 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 0/6] staging/fwserial: Address reviewer comments
Date: Mon, 28 Jan 2013 20:57:43 -0500
Message-Id: <1359424669-5723-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <20130107232206.GA15244@kroah.com>
References: <20130107232206.GA15244@kroah.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's the delta patches to get from v1 --> v2 of the patch series.
Patches 2,3 & 4 are the "sub-patches" from
  [PATCH v2 3/6] staging/fwserial: Limit tx/rx to 1394-2008 spec maximum

Peter Hurley (6):
  staging/fwserial: Remove bandwidth limit logic
  staging/fwserial: Refer to fw_device as "node"
  staging/fwserial: Simplify max payload calculation
  staging/fwserial: Fold constant MAX_ASYNC_PAYLOAD
  staging/fwserial: Assume firmware is OHCI-complaint
  staging/fwserial: Drop suggestion for helper fn integration

 drivers/staging/fwserial/TODO       |  2 --
 drivers/staging/fwserial/fwserial.c | 15 ++++++++-------
 drivers/staging/fwserial/fwserial.h | 17 +++++++----------
 3 files changed, 15 insertions(+), 19 deletions(-)

-- 
1.8.1.1

