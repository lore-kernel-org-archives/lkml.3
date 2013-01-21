Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab3AUVTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:19:31 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48017 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab3AUVT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:19:27 -0500
Date: Mon, 21 Jan 2013 22:19:20 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>
Subject: Re: [PATCH v4 03/13] scripts/gdb: Add lx-symbols command
Message-ID: <20130121211920.GP30577@one.firstfloor.org>
References: <cover.1358787929.git.jan.kiszka@siemens.com> <2ce8613114b7af6da0b55bdab8c38c69024fbd13.1358787929.git.jan.kiszka@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ce8613114b7af6da0b55bdab8c38c69024fbd13.1358787929.git.jan.kiszka@siemens.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 06:06:10PM +0100, Jan Kiszka wrote:
> This is probably the most useful helper when debugging kernel modules:
> lx-symbols will first reload vmlinux. Then it searches recursively for
> *.ko files in the specified paths and the current directory. Finally it
> walks the kernel's module list, issuing the necessary add-symbol-file
> command for each loaded module so that gdb know which module symbol
> correspond to which address.

Yes sounds very useful. I usually have to build everything
statically for gdb debugging. Would definitely use it if it was
in the standard tree.

-Andi
