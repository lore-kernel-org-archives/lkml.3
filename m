Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759107AbbA0SRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:17:10 -0500
Received: from smtp73.iad3a.emailsrvr.com ([173.203.187.73]:57807 "EHLO
	smtp73.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755482AbbA0SRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:17:08 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/6] staging: comedi: comedi_compat32.[ch] fix and tidy up
Date: Tue, 27 Jan 2015 18:16:50 +0000
Message-Id: <1422382616-6884-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422373824-12793-1-git-send-email-abbotti@mev.co.uk>
References: <1422373824-12793-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug in the handling of the 32-bit compatible version of the
COMEDI_CMD ioctl and tidy up the rest of the 32-bit compatible ioctl
handling code a bit.

v2: fix minor niggle in patch 1 and drop patch 7.

1) staging: comedi: comedi_compat32.c: fix COMEDI_CMD copy back
2) staging: comedi: comedi_compat32.h: reformat copyright comment
3) staging: comedi: comedi_compat.c: reformat copyright comment
4) staging: comedi: comedi_compat32.c: reformat other block comments
5) staging: comedi: comedi_compat32.c: align some comments
6) staging: comedi: comedi_compat32.c: absorb raw_ioctl()

 drivers/staging/comedi/comedi_compat32.c | 99 +++++++++++++++++---------------
 drivers/staging/comedi/comedi_compat32.h | 38 ++++++------
 2 files changed, 73 insertions(+), 64 deletions(-)
