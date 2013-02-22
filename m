Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab3BVKof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 05:44:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50272 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249Ab3BVKoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 05:44:32 -0500
Date: Fri, 22 Feb 2013 11:44:31 +0100
From: Michal Marek <mmarek@suse.cz>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Gilles.Muller@lip6.fr, nicolas.palix@imag.fr, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scripts/coccinelle: find constant additions that could
	be bit ors
Message-ID: <20130222104431.GF12402@pobox.suse.cz>
References: <1359821995-27910-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359821995-27910-1-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2013 at 05:19:55PM +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Semantic patch (http://coccinelle.lip6.fr/) to check for constants that are
> added but are used elsewhere as bitmasks.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied to kbuild.git#misc.

Michal
