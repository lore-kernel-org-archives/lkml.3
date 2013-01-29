Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab3A2OrE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 09:47:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757187Ab3A2Oq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 09:46:59 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] firmware: Make user-mode helper optional (v3)
Date: Tue, 29 Jan 2013 15:46:50 +0100
Message-Id: <1359470814-7993-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ming,

here is the revised patch series after your review.
In addition to points you suggested, I changed the return value of
_request_firmware_prepare() to be more naturally processed, and fixed
one forgotten unbalanced put_device() call.
The rest are same as the former version, just adapted the revised
first patch.


thanks,

Takashi

