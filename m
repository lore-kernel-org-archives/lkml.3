Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbaHEO1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:27:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50255 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbaHEO1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:27:30 -0400
Message-ID: <53E0E9D0.9040500@suse.cz>
Date: Tue, 05 Aug 2014 16:27:28 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Himangi Saraogi <himangi774@gmail.com>
CC: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Coccinelle: Script to replace if and BUG with BUG_ON
References: <20140720213635.GA12365@himangi-Dell>
In-Reply-To: <20140720213635.GA12365@himangi-Dell>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-20 23:36, Himangi Saraogi wrote:
> This script detects cases where BUG() follows an if condition on an
> expression and replaces the if condition and BUG() with a BUG_ON having
> the conditional expression of the if statement as argument.
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Is this a result of some internal review, or where does Julia's Acked-by
come from? I'm just wondering, because I haven't seen any previous
version of this patch.

Thanks,
Michal
