Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbaGJLqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:46:12 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:35458 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbaGJLqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:46:07 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] staging: comedi: remove MODULE_VERSION()
Date: Thu, 10 Jul 2014 12:45:42 +0100
Message-Id: <1404992744-3662-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of comedi drivers use MODULE_VERSION(), which is inappropriate
for in-kernel drivers.

1) staging: comedi: vmk80xx: remove MODULE_VERSION() from in-kernel module
2) staging: comedi: ni_daq_700: remove MODULE_VERSION() and commentary

 drivers/staging/comedi/drivers/ni_daq_700.c | 7 -------
 drivers/staging/comedi/drivers/vmk80xx.c    | 1 -
 2 files changed, 8 deletions(-)
