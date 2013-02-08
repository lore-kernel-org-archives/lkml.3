Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760245Ab3BHSnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 13:43:11 -0500
Received: from relay2.sgi.com ([192.48.179.30]:52579 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760201Ab3BHSnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 13:43:08 -0500
Message-Id: <20130208184305.132404589@gulag1.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Fri, 08 Feb 2013 12:43:05 -0600
From: Mike Travis <travis@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] x86: SGI UV3 Kernel Updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Kernel updates for SGI Ultraviolet system 3 (UV3).

The new MMR definitions are added, and then the updates to each module
are applied.  Afterwards, a "trim" patch reduces the size of the MMR
definitions file by about a third.  This keeps "bi-sectability" in place.

