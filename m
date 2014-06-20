Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966071AbaFTSaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:30:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40764 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934914AbaFTSaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:30:05 -0400
Date: Fri, 20 Jun 2014 20:29:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: Arvind R <arvino55@gmail.com>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3.15.1] i82975x_edac: fix dram layout inits and style
Message-ID: <20140620182951.GH11391@pd.tnic>
References: <CAA_L+UPtA9ahtF4oeGCeR27e-q=tCtoKfXqDhrJR_UgVGu9Aaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAA_L+UPtA9ahtF4oeGCeR27e-q=tCtoKfXqDhrJR_UgVGu9Aaw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 09:26:27PM +0530, Arvind R wrote:
> Subject: [PATCH 3.15.1] i82975x_edac: fix dram layout inits and style
> 
> rewrite dram layout initialisation differently based on symmetry
> of organisation. And a long pending cleanup.

Yeah, this patch is trying to do a lot of things at once and could use some
splitting into single logical changes with proper explanations in their
respective commit messages *why* the changes are needed.

Also, do you test those changes on real hardware?

Also, you have some strange coding style like

+#define^II82975X_NR_CSROWS_PER_CHANNEL

 (there's a tab between the "define" and the name)

+^I^Iif (is_symmetric)^I{$

 (tab between closing bracket and opening curly brace)

and so on. Please use single spaces like the rest of the kernel code.

Use Documentation/CodingStyle as a guide.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
