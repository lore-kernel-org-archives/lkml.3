Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbbAZMG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:06:28 -0500
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:38562 "EHLO
	smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752303AbbAZMGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:06:24 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] staging: comedi: 8253.h: reformat comments
Date: Mon, 26 Jan 2015 12:06:04 +0000
Message-Id: <1422273967-16407-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) staging: comedi: 8253.h: reformat copyright comment
2) staging: comedi: 8253.h: reformat other block comments
3) staging: comedi: 8253.h: use usual style for single-line comments

 drivers/staging/comedi/drivers/8253.h | 92 ++++++++++++++++++-----------------
 1 file changed, 48 insertions(+), 44 deletions(-)
