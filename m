Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455AbaLaMKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 07:10:36 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:53621 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaLaMKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 07:10:35 -0500
Date: Tue, 30 Dec 2014 18:02:02 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 1/8] Documentation/memory-barriers.txt: Fix smp typo
Message-ID: <20141231020202.GN11609@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1419757883-4423-1-git-send-email-dave@stgolabs.net>
 <1419757883-4423-2-git-send-email-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419757883-4423-2-git-send-email-dave@stgolabs.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14123112-0025-0000-0000-0000075F1502
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2014 at 01:11:16AM -0800, Davidlohr Bueso wrote:
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>

Good catch, queued for 3.20.

							Thanx, Paul

> ---
>  Documentation/memory-barriers.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> index 70a09f8..7086f83 100644
> --- a/Documentation/memory-barriers.txt
> +++ b/Documentation/memory-barriers.txt
> @@ -750,7 +750,7 @@ In summary:
>        However, they do -not- guarantee any other sort of ordering:
>        Not prior loads against later loads, nor prior stores against
>        later anything.  If you need these other forms of ordering,
> -      use smb_rmb(), smp_wmb(), or, in the case of prior stores and
> +      use smp_rmb(), smp_wmb(), or, in the case of prior stores and
>        later loads, smp_mb().
> 
>    (*) If both legs of the "if" statement begin with identical stores
> -- 
> 2.1.2
> 

