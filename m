Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaFJJpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 05:45:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48727 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbaFJJpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:45:13 -0400
From: Juergen Borleis <jbe@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, kernel@pengutronix.de
Subject: Power/battery/BQ27xxx: some fixes and hot-plug support
Date: Tue, 10 Jun 2014 11:44:46 +0200
Message-Id: <1402393493-3559-1-git-send-email-jbe@pengutronix.de>
X-Mailer: git-send-email 2.0.0.rc2
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:a236:9fff:fe00:814
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BQ27425 support needs some fixes, as it differs from the main
BQ27000 and the BQ27500 somehow. Also we need to distinguish two existing
BQ27425 device types due to a firmware change.

And these kind of devices can be part of the attached battery or part of the
board with an externally attached battery. In both cases we must consider a
battery change can be handled and at least the battery connection state gets
reported correctly.

Please keep me on CC as I'm not subscribed to LKML.

Comments are welcome.
Juergen

