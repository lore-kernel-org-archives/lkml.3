Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088Ab3CYSuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 14:50:14 -0400
Received: from relay3.sgi.com ([192.48.152.1]:55836 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932917Ab3CYSuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 14:50:09 -0400
Message-Id: <20130325185007.321022858@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 25 Mar 2013 13:50:07 -0500
From: Mike Travis <travis@sgi.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        kgdb-bugreport@lists.sourceforge.net, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/15] x86/UV/KDB/NMI: Updates for NMI/KDB handler for SGI UV
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These are kernel updates for the NMI/KDB handler on the SGI
Ultraviolet System.

* Fix problem where 'quit' to more> prompt doesn't stop output.
* Fix problem where reg dump shows letter 'd' in first column of
  every line.
* Up the number of LINES so the entire entry message is displayed.
* Moves KDB header defines to externally visable header so external
  KDB modules can be built.
* Exports some significant KDB functions for use by external modules.
* Consolidates the '| grep' support into new kdb_grep.c file.
* Updates kdb grep support to add some new options.
* Restablishes support for kdump from the kdb prompt.
* Adds back in the 'pshelp' command.
* Adds new entry into KGDB for systems with global NMI support.
* Adds new reason code to enter KDB that's not considered an error.
* Adds support for external 'uvtrace' module.
* Updates NMI support for new internal system (SMM) NMI handler.
* Adds back the capability of NMI entering KDB/KGDB.

-- 
