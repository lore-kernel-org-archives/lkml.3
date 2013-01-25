Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab3AYQFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:05:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41070 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755771Ab3AYQFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:05:38 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] firmware: Make user-mode helper optional (v2)
Date: Fri, 25 Jan 2013 17:05:25 +0100
Message-Id: <1359129929-29291-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ming,

this is a series of revised patches to make the user-mode helper in the
firmware loader optional.  A few bugs (typos) have been fixed during
this rewrite, and a small optimization was added in the last patch.
I hope this would be good enough for review.


thanks,

Takashi
