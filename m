Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbaE2LQC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 07:16:02 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:57154 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175AbaE2LQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 07:16:00 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Fred Brooks <frederick.brooks@microchip.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] staging: comedi: ni_daq_700: AI additions
Date: Thu, 29 May 2014 12:15:45 +0100
Message-Id: <1401362147-5965-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch reformats (and slightly changes) the driver comment to
avoid checkpatch warnings for the second patch.

The second patch adds functionality to the AI subdevice and is the work
of the original author, Fred Brooks.

1) staging: comedi: ni_daq_700: update driver comment
2) staging: comedi: ni_daq_700: add AI range and input mode

 drivers/staging/comedi/drivers/ni_daq_700.c | 98 +++++++++++++++++++----------
 1 file changed, 65 insertions(+), 33 deletions(-)
