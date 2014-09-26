Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbaIZLnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:43:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35802 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619AbaIZLnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:43:13 -0400
Date: Fri, 26 Sep 2014 13:43:10 +0200
From: Michal Marek <mmarek@suse.cz>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Gilles.Muller@lip6.fr, nicolas.palix@imag.fr, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org, u.kleine-koenig@pengutronix.de,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] coccinelle: misc: semantic patch to delete overly
	complex return code processing
Message-ID: <20140926114309.GA31096@pobox.suse.cz>
References: <1408772085-28818-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408772085-28818-1-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2014 at 07:34:45AM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> This semantic patch simplifies cases where the effect of the processing of
> a function call's return code is just to return the result of the function
> directly.  It may also delete a local return flag variable, if this is no
> longer used.
> 
> This was proposed by Uwe Kleine-König.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied to kbuild.git#misc, thanks.

Michal
