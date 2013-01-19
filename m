Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab3ASKSv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 05:18:51 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:63340 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3ASKSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 05:18:50 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 0/2] staging: line6: clean up MIDI post-processing functions
Date: Sat, 19 Jan 2013 11:18:42 +0100
Message-Id: <1358590724-30961-1-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The line6 driver inspects fewer MIDI messages than in previous versions.  The
conditionals to match these MIDI messages were left in place.  This series
removes unused conditionals in order to make the MIDI post-processing functions
easier to read.

Applies to linux-next/master.

Stefan Hajnoczi (2):
  staging: line6: clean up line6_pod_process_message()
  staging: line6: clean up line6_variax_process_message()

 drivers/staging/line6/pod.c    | 96 +++++++++---------------------------------
 drivers/staging/line6/variax.c | 14 ------
 2 files changed, 19 insertions(+), 91 deletions(-)

-- 
1.8.0.2

