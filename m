Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab3KGFNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 00:13:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41093 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab3KGFNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 00:13:48 -0500
Date: Wed, 6 Nov 2013 22:30:33 +0100
From: Michal Marek <mmarek@suse.cz>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kbuild: replace unbounded sprintf call in modpost
Message-ID: <20131106213032.GE22142@pobox.suse.cz>
References: <20131025131443.GA7759@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131025131443.GA7759@www.outflux.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 06:14:43AM -0700, Kees Cook wrote:
> The modpost tool could overflow its stack buffer if someone was running
> with an insane shell environment. Regardless, it's technically a bug,
> so this fixes it to truncate the string instead of seg-faulting.
> 
> Found by Coverity.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Applied to kbuild.git#kbuild.

Michal
