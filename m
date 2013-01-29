Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab3A2OPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 09:15:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59270 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756258Ab3A2OPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 09:15:20 -0500
Date: Tue, 29 Jan 2013 15:15:18 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        "David S. Miller" <davem@davemloft.net>,
        Fenghua Yu <fenghua.yu@intel.com>, Kay Sievers <kay@vrfy.org>,
        linux-doc@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Rob Landley <rob@landley.net>, sparclinux@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v5 00/20] Add gdb python scripts as kernel debugging
 helpers
Message-ID: <20130129141518.GI14302@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Jason Wessel <jason.wessel@windriver.com>,
	kgdb-bugreport@lists.sourceforge.net,
	Andi Kleen <andi@firstfloor.org>, Tom Tromey <tromey@redhat.com>,
	Ben Widawsky <ben@bwidawsk.net>,
	"David S. Miller" <davem@davemloft.net>,
	Fenghua Yu <fenghua.yu@intel.com>, Kay Sievers <kay@vrfy.org>,
	linux-doc@vger.kernel.org, linux-ia64@vger.kernel.org,
	linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
	Rob Landley <rob@landley.net>, sparclinux@vger.kernel.org,
	Tony Luck <tony.luck@intel.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 01:37:43PM +0100, Jan Kiszka wrote:
> Version 5 comes with the following changes:
>  - moved tutorial into Documentation/gdb-kernel-debugging.txt
>  - improved caching of gdb.Type objects, ensure they are in sync with
>    currently loaded symbols
>  - added new functions and commands
>     - lx_module -- Find module by name and return the module variable
>     - lx_modvar -- Return global variable of a module
>     - lx-lsmod -- List currently loaded modules
> 
> See http://lkml.indiana.edu/hypermail/linux/kernel/1210.0/01598.html for
> the original description and
> 
>     git://git.kiszka.org/linux.git queues/gdb-scripts
> 
> for the latest version.

Ok, I've seldomly shown any feelings when acking a patch{,set} besides
maybe "hm, ok, fine" but this patchset is very very cool and it is an
enormous fun playing with it.

So maybe this is the most enthusiasm I've shown sofar:

Emphatically-acked-by: Borislav Petkov <bp@suse.de>

Thanks Jan, very good work!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
