Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaJSP5s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 11:57:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:40788 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaJSP5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 11:57:38 -0400
From: Christoph Hellwig <hch@lst.de>
To: Chandra Seetharaman <sekharan@us.ibm.com>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>
Cc: Sean Stewart <Sean.Stewart@netapp.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org
Subject: device handler cleanups
Date: Sun, 19 Oct 2014 17:59:58 +0200
Message-Id: <1413734404-1426-1-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.9.1
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series contains a couple easy cleanups for the device handler
infrastructure.  I think some more work could be done in the longer run,
e.g. by using a class_device interface to attach to the scsi_device,
similar to how the /dev/sg devices work.

