Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab3AUVUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:20:21 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48021 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab3AUVUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:20:15 -0500
Date: Mon, 21 Jan 2013 22:20:15 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH v4 06/13] scripts/gdb: Add lx-dmesg command
Message-ID: <20130121212015.GQ30577@one.firstfloor.org>
References: <cover.1358787929.git.jan.kiszka@siemens.com> <40443e3682bae5c8227434f945f7297d49af4afb.1358787929.git.jan.kiszka@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40443e3682bae5c8227434f945f7297d49af4afb.1358787929.git.jan.kiszka@siemens.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 06:06:13PM +0100, Jan Kiszka wrote:
> This pokes into the log buffer of the debugged kernel, dumping it to the
> gdb console. Helping in case the target should or can no longer execute
> dmesg itself.

Very useful, as this got very painful when the log buffer was changed
a few releases ago.

-Andi
