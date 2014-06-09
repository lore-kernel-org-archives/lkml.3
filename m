Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933744AbaFIQ7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 12:59:38 -0400
Received: from one.firstfloor.org ([193.170.194.197]:45680 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbaFIQ7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 12:59:36 -0400
Date: Mon, 9 Jun 2014 18:59:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Fenghua Yu <fenghua.yu@intel.com>, Kay Sievers <kay@vrfy.org>,
        linux-doc@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Pantelis Koukousoulas <pktoss@gmail.com>,
        Rob Landley <rob@landley.net>, Rusty Russell <rusty@rustcorp.com.au>,
        sparclinux@vger.kernel.org, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v8 00/22] Add gdb python scripts as kernel debugging
 helpers
Message-ID: <20140609165934.GT25366@two.firstfloor.org>
References: <cover.1402075136.git.jan.kiszka@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1402075136.git.jan.kiszka@siemens.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I looked through the patches and from a quick look they all look good to
me. I especially like the support for per cpu variables. I had a lot of 
trouble with those in the past with various debugging setups.

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
