Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab3LBOic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:38:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46592 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab3LBOia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:38:30 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/4] Add request_firmware_direct() for microcode loader
Date: Mon,  2 Dec 2013 15:38:15 +0100
Message-Id: <1385995099-11901-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

this is the revised patchset, just rebased to be applicable cleanly
to 3.13-rc tree.  Other than that, there is no change since v3.

 [PATCH v4 1/4] firmware: Introduce request_firmware_direct()
 [PATCH v4 2/4] microcode: Use request_firmware_direct()
 [PATCH v4 3/4] firmware: Use bit flags instead of boolean combos
 [PATCH v4 4/4] firmware: Suppress fallback warnings when


thanks,

Takashi

