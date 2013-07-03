Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab3GCNmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 09:42:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34158 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445Ab3GCNmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 09:42:16 -0400
Date: Wed, 3 Jul 2013 15:42:14 +0200
From: Michal Marek <mmarek@suse.cz>
To: Nicolas Palix <nicolas.palix@imag.fr>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] Coccinelle: Update the documentation
Message-ID: <20130703134214.GC30955@sepie.suse.cz>
References: <CAK9yfHyM7OrOtxWN56J06RAVBc-q0idDdhFjYzT3=opw-bZuXA@mail.gmail.com>
 <1371729619-18719-1-git-send-email-nicolas.palix@imag.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371729619-18719-1-git-send-email-nicolas.palix@imag.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 02:00:19PM +0200, Nicolas Palix wrote:
>  - The new default mode is 'report'.
>  - The available modes are detailed a bit more.
>  - Some information about the use of spatch options are
>    also given concerning the use of indexing tools.
> 
> Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>

Applied to kbuild.git#misc, thanks.

Michal
