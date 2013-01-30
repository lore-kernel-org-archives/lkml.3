Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab3A3Kf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 05:35:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41743 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449Ab3A3KfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 05:35:23 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] firmware: Make user-mode helper optional (v4)
Date: Wed, 30 Jan 2013 11:35:05 +0100
Message-Id: <1359542109-3043-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ming,

this is again revised patch series.
The usermodehelper lock is applied again for the direct loading case,
the wrongly removed put_device() is revived again (with a comment).

I have a patch on top of this for moving usermodehelper lock out of
the direct loading case, but let's discuss about a better way.


thanks,

Takashi

