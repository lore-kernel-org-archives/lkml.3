Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292Ab3HMUpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:45:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39527 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759134Ab3HMUpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:45:08 -0400
Message-ID: <520A9ACE.7080809@suse.cz>
Date: Tue, 13 Aug 2013 22:45:02 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, linux-kernel@vger.kernel.org,
        cocci@systeme.lip6.fr
Subject: Re: [PATCH v3] coccinelle: replace 0/1 with false/true in functions
 returning bool
References: <1376071193-21146-1-git-send-email-linux@rasmusvillemoes.dk> <1376255112-22787-1-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1376255112-22787-1-git-send-email-linux@rasmusvillemoes.dk>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 11.8.2013 23:05, Rasmus Villemoes napsal(a):
> This semantic patch replaces "return {0,1};" with "return
> {false,true};" in functions returning bool.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
> v2: Simplified script, and eliminate whitespace mangling at the same
> time. Thanks to Julia Lawall.
> 
> v3: Further improvements from Julia. In particular, it now also does
> header files.

Applied to kbuild.git#misc.

Michal

