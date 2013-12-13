Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab3LMUtp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 15:49:45 -0500
Received: from smtpauth05h.mfg.siteprotect.com ([64.26.60.146]:60402 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752122Ab3LMUtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 15:49:43 -0500
Date: Fri, 13 Dec 2013 15:52:25 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Andi Kleen <ak@linux.intel.com>
cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Subject: [patch] perf properly document the new transaction sample type
In-Reply-To: <20131213203806.GR22695@tassilo.jf.intel.com>
Message-ID: <alpine.DEB.2.02.1312131548450.10372@pianoman.cluster.toy>
References: <1379688044-14173-2-git-send-email-andi@firstfloor.org> <tip-fdfbbd07e91f8fe387140776f3fd94605f0c89e5@git.kernel.org> <alpine.DEB.2.02.1312131526550.10244@pianoman.cluster.toy> <20131213203806.GR22695@tassilo.jf.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020201.52AB72E7.00DE,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit fdfbbd07e91f8fe3871 "perf: Add generic transaction flags"
added support for PERF_SAMPLE_TRANSACTION but forgot to add documentation
for the sample type to include/uapi/linux/perf_event.h

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index e1802d6..959d454 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -679,6 +679,7 @@ enum perf_event_type {
 	 *
 	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
 	 *	{ u64			data_src; } && PERF_SAMPLE_DATA_SRC
+	 *	{ u64			transaction; } && PERF_SAMPLE_TRANSACTION
 	 * };
 	 */
 	PERF_RECORD_SAMPLE			= 9,
