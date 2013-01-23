Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab3AWL6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 06:58:25 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43231 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755246Ab3AWL6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 06:58:23 -0500
Date: Wed, 23 Jan 2013 13:01:16 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v4 01/13] scripts/gdb: Add infrastructure
Message-ID: <20130123120116.GC4256@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Jason Wessel <jason.wessel@windriver.com>,
	kgdb-bugreport@lists.sourceforge.net,
	Andi Kleen <andi@firstfloor.org>, Tom Tromey <tromey@redhat.com>,
	Ben Widawsky <ben@bwidawsk.net>, Michal Marek <mmarek@suse.cz>,
	linux-kbuild@vger.kernel.org
References: <cover.1358787929.git.jan.kiszka@siemens.com>
 <1e49f090f16f3e22711a27f473e2ed604f6a249f.1358787929.git.jan.kiszka@siemens.com>
 <20130123114157.GB4256@pd.tnic>
 <50FFCD04.2030207@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50FFCD04.2030207@siemens.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 12:44:04PM +0100, Jan Kiszka wrote:
> I wonder why we should do this, remove the convenience of the
> automatic script setup, but I'm open for arguments.

Only one: you get the symlink

vmlinux-gdb.py -> /..../scripts/gdb/vmlinux-gdb.py

created automatically when CONFIG_DEBUG_INFO is enabled and people who
enable CONFIG_DEBUG_INFO for other reasons and don't want to use gdb to
debug the kernel don't need it but will get it anyway.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
