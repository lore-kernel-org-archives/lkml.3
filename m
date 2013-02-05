Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab3BEW04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:26:56 -0500
Received: from relay2.sgi.com ([192.48.179.30]:50296 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757404Ab3BEW0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:26:50 -0500
Message-Id: <20130205222648.204965172@gulag1.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 05 Feb 2013 16:26:48 -0600
From: Mike Travis <travis@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] x86: SGI UV3 Kernel Updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Kernel updates for SGI Ultraviolet system 3 (UV3)

The new MMR definitions are added, and then the updates
to each module are applied.  Afterwards, a "trim" patch
reduces the size of the MMR definitions file by about
a third.  This keeps "bi-sectability" in place.

