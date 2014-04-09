Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249AbaDIHM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 03:12:56 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57785 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750758AbaDIHMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 03:12:55 -0400
Date: Wed, 9 Apr 2014 09:12:34 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Neil Greatorex <neil@fatboyfat.co.uk>,
        linux-arm-kernel@lists.infradead.org,
        Matthew Minter <matthew_minter@xyratex.com>,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v2] bus: mvebu-mbus: Avoid setting an undefined window
 size
Message-ID: <20140409091234.20f2e547@skate>
In-Reply-To: <20140409061128.GC16465@1wt.eu>
References: <1397000654-10849-1-git-send-email-jgunthorpe@obsidianresearch.com>
	<20140409061128.GC16465@1wt.eu>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Willy Tarreau,

On Wed, 9 Apr 2014 08:11:29 +0200, Willy Tarreau wrote:

> The WARN is correctly emitted for both igb ports here, but unfortunately
> despite EINVAL, I still get the panic. Also I find it surprizing that it
> reports sizes ending in ffff. I read the patch and it looks correct, so
> we possibly have something else wrong here.

Yes, the panic is expected: Jason's patch is not *fixing* anything,
it's just telling you *why* it's going to panic.

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
