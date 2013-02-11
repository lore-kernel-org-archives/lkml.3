Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759753Ab3BKTpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 14:45:12 -0500
Received: from relay1.sgi.com ([192.48.179.29]:50382 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758798Ab3BKTpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 14:45:08 -0500
Message-Id: <20130211194508.033167376@gulag1.americas.sgi.com>
User-Agent: quilt/0.47-15.17.1
Date: Mon, 11 Feb 2013 13:45:08 -0600
From: Mike Travis <travis@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] x86/UV/UV3: Kernel Updates for SGI UV3.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Kernel updates for SGI Ultraviolet System 3 (UV3).

The new MMR definitions are added, and then the updates to each module
are applied.  Afterwards, a "trim" patch reduces the size of the MMR
definitions file by about a third.  This keeps "bi-sectability" in place.

