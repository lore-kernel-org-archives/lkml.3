Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab3J3Ff1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 01:35:27 -0400
Received: from one.firstfloor.org ([193.170.194.197]:38737 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab3J3FfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 01:35:24 -0400
Date: Wed, 30 Oct 2013 06:35:21 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v6 01/21] scripts/gdb: Add infrastructure
Message-ID: <20131030053521.GU29695@two.firstfloor.org>
References: <cover.1382950737.git.jan.kiszka@siemens.com>
 <74596df6935455908a146314b9b42ae2d79f6712.1382950737.git.jan.kiszka@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74596df6935455908a146314b9b42ae2d79f6712.1382950737.git.jan.kiszka@siemens.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The loading mechanism is based on gdb loading for <objfile>-gdb.py when
> opening <objfile>. Therefore, this places a corresponding link to the
> main helper script into the output directory that contains vmlinux.

> This feature depends on CONFIG_DEBUG_INFO.

Could you make this a separate config option? Having the links for
people who don't use gdb would be ugly.

-Andi
