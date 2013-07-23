Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab3GWUQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 16:16:24 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:33632 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757801Ab3GWUQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 16:16:22 -0400
Date: Tue, 23 Jul 2013 15:16:15 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] rsxx: RSXX driver Bug fixes.
Message-ID: <20130723201615.GA12914@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072320-3620-0000-0000-000003A78F5B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

The incoming patch series contains 4 patches for the
rsxx driver (drivers/block/rsxx). They are all bug
fixes.

Patch1:
	Our adapter is going through a name change.

Patch2:
	The driver isn't removing the IDA entry during
	driver unload. This becomes a problem during
	DLPAR remove.

Patch3:
	These are changes mentioned by other members
	of the Linux Community. Basically, returning 
	the wrong statuses on a couple of failure
	cases in the driver.

Patch 4:
	The driver wasn't handling the return value
	of pci_map_page correctly for the PowerPC
	architecture. This also uncovered a double
	free scenario that is fixed here.
	

