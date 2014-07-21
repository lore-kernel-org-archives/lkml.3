Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979AbaGUQ3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 12:29:21 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:59333 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932726AbaGUQ3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 12:29:19 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] staging: comedi: ni_6527 edge detection changes
Date: Mon, 21 Jul 2014 17:29:04 +0100
Message-Id: <1405960146-8959-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add partial support for INSN_CONFIG_DIGITAL_TRIG as an alternative to
INSN_CONFIG_CHANGE_NOTIFY, and initialize the edge detection registers.

1) staging: comedi: ni_6527: support INSN_CONFIG_DIGITAL_TRIG
2) staging: comedi: ni_6527: reset edge detection registers

 drivers/staging/comedi/drivers/ni_6527.c | 75 +++++++++++++++++++++++++++-----
 1 file changed, 64 insertions(+), 11 deletions(-)
