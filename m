Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbbAUMIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:08:30 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:56936 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbbAUMIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:08:21 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Finn Thain <fthain@telegraphics.com.au>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] scsi: Some seq_file cleanups/optimizations
Organization: D03
References: <1417221258-4937-1-git-send-email-linux@rasmusvillemoes.dk>
	<1417561854-17188-1-git-send-email-linux@rasmusvillemoes.dk>
X-Hashcash: 1:20:150121:fthain@telegraphics.com.au::257t8VnnvE/qA/yv:0000000000000000000000000000000000019YP
X-Hashcash: 1:20:150121:linux-kernel@vger.kernel.org::K/7x3nZOY2ALHySl:0000000000000000000000000000000001p84
X-Hashcash: 1:20:150121:linux-scsi@vger.kernel.org::A5stmtnhJV7/kBFF:0000000000000000000000000000000000035/Q
X-Hashcash: 1:20:150121:jbottomley@parallels.com::mYcxXsSm8z/7nJw4:00000000000000000000000000000000000009n3Z
Date: Wed, 21 Jan 2015 13:08:17 +0100
In-Reply-To: <1417561854-17188-1-git-send-email-linux@rasmusvillemoes.dk>
	(Rasmus Villemoes's message of "Wed, 3 Dec 2014 00:10:48 +0100")
Message-ID: <873874uyj2.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03 2014, Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:

> These patches mostly replace seq_printf with simpler and faster
> equivalents, e.g. seq_printf(m, "something") => seq_puts(m,
> "something") and seq_printf(m, "\n") => seq_putc(m, '\n). But before
> my Coccinelle scripts could be unleashed I had to clean up an
> unnecessary macro.
>
> The patches don't change the semantics of the code (well, that's the
> idea anyway), but should make it slightly smaller and faster.
>
> v2: Redone on top of git://git.infradead.org/users/hch/scsi-queue.git drivers-for-3.19
>

Ping. Was this picked up, or did it just go to /dev/null?

Rasmus
