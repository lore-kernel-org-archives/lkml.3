Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab3FNNeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 09:34:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46621 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942Ab3FNNeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 09:34:02 -0400
Date: Fri, 14 Jun 2013 15:34:01 +0200
From: Michal Marek <mmarek@suse.cz>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: cocci@systeme.lip6.fr, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/coccinelle: check for field address argument to
 kfree
Message-ID: <20130614133401.GB5402@sepie.suse.cz>
References: <1370708502-21907-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370708502-21907-1-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 08, 2013 at 06:21:42PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> The argument to kfree should not be the address of a structure field.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied to kbuild.git#misc.

Thanks,
Michal
