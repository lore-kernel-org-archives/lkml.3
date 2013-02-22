Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab3BVKZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 05:25:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49608 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220Ab3BVKZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 05:25:05 -0500
Date: Fri, 22 Feb 2013 11:25:04 +0100
From: Michal Marek <mmarek@suse.cz>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Julia.Lawall@lip6.fr, Gilles.Muller@lip6.fr, nicolas.palix@imag.fr,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, elezegarcia@gmail.com
Subject: Re: [PATCH V2] scripts/coccinelle/misc/memcpy-assign.cocci:
	Replace memcpy with struct assignment
Message-ID: <20130222102503.GD12402@pobox.suse.cz>
References: <1358978790-2990-1-git-send-email-peter.senna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358978790-2990-1-git-send-email-peter.senna@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 08:06:30PM -0200, Peter Senna Tschudin wrote:
> There are error-prone memcpy() that can be replaced by struct
> assignment that are type-safe and much easier to read. This semantic
> patch looks for memcpy() that can be replaced by struct assignment.
> 
> Inspired by patches sent by Ezequiel Garcia <elezegarcia@gmail.com>
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> ---
> Changes from V1:
>  Updated commit message
>  Changed Confidence comment to High on the semantic patch

Applied to kbuild.git#misc, thanks.

Michal
