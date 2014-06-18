Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966246AbaFRKkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 06:40:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41428 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965568AbaFRKkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 06:40:11 -0400
Date: Wed, 18 Jun 2014 12:38:37 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Borislav Petkov <bp@alien8.de>
cc: Paul Bolle <pebolle@tiscali.nl>, Richard Weinberger <richard@nod.at>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 05/28] Remove MPILIB_EXTRA
In-Reply-To: <20140618094821.GA24024@pd.tnic>
Message-ID: <alpine.LNX.2.00.1406181237480.2303@pobox.suse.cz>
References: <1391971686-9517-1-git-send-email-richard@nod.at> <1391971686-9517-6-git-send-email-richard@nod.at> <1391977123.25855.24.camel@x220> <1397552794.1985.19.camel@x220> <20140415092147.GA4302@pd.tnic> <1403078994.1984.47.camel@x220>
 <20140618094821.GA24024@pd.tnic>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Borislav Petkov wrote:

> > This oneliner is neither part of v3.16-rc1 nor part of linux-next. It
> > applies cleanly to next-20140618. Should I hope that Jiri Kosina wants
> > to take it for trivial (CC-ed)?
> 
> Yeah, he will.

It's not in my queue of patches to be processed though, so I guess I 
wasn't CCed on the initial submission. Paul, if you want me to pick it up, 
please bounce it to trivial@kernel.org as well. Thanks,

-- 
Jiri Kosina
SUSE Labs
