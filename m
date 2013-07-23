Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab3GWNiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 09:38:54 -0400
Received: from ozlabs.org ([203.10.76.45]:37158 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566Ab3GWNix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 09:38:53 -0400
Date: Tue, 23 Jul 2013 23:38:51 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/8xx: Remove last traces of 8XX_MINIMAL_FPEMU
Message-ID: <20130723133851.GD31944@concordia>
References: <1373964998.2591.57.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373964998.2591.57.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 10:56:38AM +0200, Paul Bolle wrote:
> The Kconfig symbol 8XX_MINIMAL_FPEMU was removed in commit 968219fa33
> ("powerpc/8xx: Remove 8xx specific "minimal FPU emulation""). But that
> commit didn't remove all code depending on that symbol. Do so now.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Not even compile tested!

Help yourself to a cross compiler :)

https://www.kernel.org/pub/tools/crosstool/


cheers
