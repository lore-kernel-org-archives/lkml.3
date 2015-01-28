Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465AbbA2BrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:47:16 -0500
Received: from smtp65.iad3a.emailsrvr.com ([173.203.187.65]:57495 "EHLO
	smtp65.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757812AbbA2BrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:47:07 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] staging: comedi: reformat comedi_fops and range comments
Date: Wed, 28 Jan 2015 18:41:44 +0000
Message-Id: <1422470510-9309-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) staging: comedi: comedi_fops.c: reformat copyright header
2) staging: comedi: comedi_fops.c: document exported functions
3) staging: comedi: comedi_fops.c: reformat ioctl handler comments
4) staging: comedi: range.c: reformat ioctl handler comment
5) staging: comedi: range.c: reformat copyright comment
6) staging: comedi: comedi_fops.c: reformat remaining block comments

 drivers/staging/comedi/comedi_fops.c | 437 +++++++++++++++++++----------------
 drivers/staging/comedi/range.c       |  56 ++---
 2 files changed, 272 insertions(+), 221 deletions(-)
