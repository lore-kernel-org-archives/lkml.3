Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab3FNNdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 09:33:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46564 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab3FNNdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 09:33:00 -0400
Date: Fri, 14 Jun 2013 15:32:57 +0200
From: Michal Marek <mmarek@suse.cz>
To: Nicolas Palix <nicolas.palix@imag.fr>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Brice Goglin <Brice.Goglin@inria.fr>, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Coccinelle: Make 'report' the default mode
Message-ID: <20130614133256.GA5402@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370554793-9152-2-git-send-email-nicolas.palix@imag.fr>
 <1370554793-9152-1-git-send-email-nicolas.palix@imag.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 11:39:52PM +0200, Nicolas Palix wrote:
> It appears that the 'report' mode is the one always
> provided by the semantic patches included in the kernel.
> It is thus more natural to select it by default.
> 
> The 'chain' mode is however kept and the 'patch' mode
> is still the first tried in that case.
> 
> Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>

On Thu, Jun 06, 2013 at 11:39:53PM +0200, Nicolas Palix wrote:
> Add Michal Marek and the misc branch of the kbuild tree
> in the Coccinelle section of MAINTAINERS.
> 
> Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>

I applied both patches to kbuild.git#misc.

Thanks,
Michal
