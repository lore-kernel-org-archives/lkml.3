Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab3EHG4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 02:56:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42007 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791Ab3EHG4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 02:56:48 -0400
From: Takashi Iwai <tiwai@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 0/3] firmware: Fix usermodehelper deadlock at shutdown
Date: Wed,  8 May 2013 08:56:34 +0200
Message-Id: <1367996197-32748-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is a series of patches for the issue we faced in the firmware
loader code during debugging the problem with dell_rbu driver with
3.9 kernel.

The original problem was that the shutdown gets stuck when DELL BIOS
update is performed.  This turned out to be a problem in the firmware
loader.  Although the reason of dell_rbu driver breakage is still
unclear, we should fix the firmware loader side, at least, not to
stall during shutdown.


thanks,

Takashi

