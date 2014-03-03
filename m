Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbaCCVNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 16:13:46 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47505 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbaCCVNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 16:13:40 -0500
Date: Mon, 3 Mar 2014 15:13:36 -0600
From: Andrew Ruder <andy@aeruder.net>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Leon Pollak <leonp@plris.com>, Richard Weinberger <richard@nod.at>,
        linux-mtd@lists.infradead.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: What is wrong?
Message-ID: <20140303211336.GA7369@gmail.com>
Mail-Followup-To: Brian Norris <computersforpeace@gmail.com>,
	Leon Pollak <leonp@plris.com>, Richard Weinberger <richard@nod.at>,
	linux-mtd@lists.infradead.org,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Artem Bityutskiy <dedekind1@gmail.com>
References: <4315632.KkRm7kzq26@leonp.plris.com>
 <20140227011148.GI4194@ld-irv-0074>
 <1553411.O1igofskp7@leonp.plris.com>
 <20140227212208.GG13420@norris-Latitude-E6410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227212208.GG13420@norris-Latitude-E6410>
User-Agent: Mutt/1.5.21+155 (d3096e8796e7) (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 01:22:08PM -0800, Brian Norris wrote:
> Perhaps Richard or Andrew can comment on whether this patch should help
> you. But I think JFFS2 on NAND uses write-buffered support which can be
> affected by this bug.

Definitely sounds like the same issue and I'm kind of glad to see it
crop up in another filesystem.  Also glad you Cc'd me with the URL
because I had the painful task of recreating this issue on another
filesystem on my TODO list as I didn't think it had ever been committed.

Cheers,
Andy
