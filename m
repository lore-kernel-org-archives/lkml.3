Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbaIDRFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 13:05:10 -0400
Received: from pegasus3.altlinux.org ([194.107.17.103]:56411 "EHLO
	pegasus3.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbaIDRFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 13:05:08 -0400
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Sep 2014 13:05:07 EDT
Date: Thu, 4 Sep 2014 20:55:00 +0400
From: Michael Shigorin <mike@altlinux.org>
To: linux-kernel@vger.kernel.org
Cc: Christophe Ricard <christophe.ricard@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: PROBLEM: 3.17-rc3 module dependency loops
Message-ID: <20140904165500.GK2515@imap.altlinux.org>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Christophe Ricard <christophe.ricard@gmail.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hello,
I've spotted these depmod loops while building 3.17-rc3:

depmod: ERROR: Found 6 modules in dependency cycles!
depmod: ERROR: Cycle detected: st21nfcb -> ndlc -> nci -> nfc -> st21nfcb
depmod: ERROR: Cycle detected: nci -> nfc -> nci

Had to disable NFC_NCI, NFC_ST21NFCB.

PS: not subscribed to LKML, CC please.

-- 
š---- WBR, Michael Shigorin / http://altlinux.org
šš------ http://opennet.ru / http://anna-news.info
