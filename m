Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab3KGE00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 23:26:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37063 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab3KGE0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 23:26:23 -0500
Date: Wed, 6 Nov 2013 22:27:02 +0100
From: Michal Marek <mmarek@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Joe Perches <joe@perches.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/3] Kbuild: Handle longer symbols in kallsyms.c v2
Message-ID: <20131106212702.GC22142@pobox.suse.cz>
References: <1382456783-22826-1-git-send-email-andi@firstfloor.org> <1382456783-22826-3-git-send-email-andi@firstfloor.org> <1382459794.2041.91.camel@joe-AO722> <20131023130753.GO29695@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131023130753.GO29695@two.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 03:07:53PM +0200, Andi Kleen wrote:
> 
> Also warn for too long symbols
> 
> v2: Add missing newline. Use 255 max (Joe Perches)
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Applied to kbuild.git#kbuild.

Michal
