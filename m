Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab3D2NYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 09:24:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45337 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab3D2NYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 09:24:49 -0400
Date: Mon, 29 Apr 2013 15:24:47 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Christoph Lameter <cl@linux.com>
Cc: Joe Perches <joe@perches.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [TRIVIAL PATCH 23/26] mm: Convert print_symbol to %pSR
In-Reply-To: <0000013b90bb4f41-3c381041-b26d-4534-b983-a025858bb748-000000@email.amazonses.com>
Message-ID: <alpine.LNX.2.00.1304291524360.11889@pobox.suse.cz>
References: <cover.1355335227.git.joe@perches.com> <96a83ddb7f8571afe8b3b3b6e7fc9dc3ff81dda5.1355335228.git.joe@perches.com> <0000013b90bb4f41-3c381041-b26d-4534-b983-a025858bb748-000000@email.amazonses.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Dec 2012, Christoph Lameter wrote:

> > Use the new vsprintf extension to avoid any possible
> > message interleaving.
> 
> Acked-by: Christoph Lameter <cl@linux.com>

Doesn't seem to be in linux-next as of today, I am taking this one.

-- 
Jiri Kosina
SUSE Labs
