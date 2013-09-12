Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab3ILAP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 20:15:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:38359 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901Ab3ILAP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 20:15:56 -0400
Message-ID: <1378944911.4066.12.camel@pasglop>
Subject: Re: [PATCH] powerpc 8xx: Fixing issue with CONFIG_PIN_TLB
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Thu, 12 Sep 2013 10:15:11 +1000
In-Reply-To: <1378939017.12204.409.camel@snotra.buserror.net>
References: <201309111644.r8BGiuDZ016325@localhost.localdomain>
	 <1378939017.12204.409.camel@snotra.buserror.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-11 at 17:36 -0500, Scott Wood wrote:
> I wonder why we don't start from entry 31 so we can actually make use of
> that autodecrement.  What will happen when we load the first normal TLB
> entry later on?  I don't see any setting of SPRN_MD_CTR after this code,
> so won't it overwrite entry 30 (the middle 8M) in the CONFIG_PIN_TLB
> case?
> 
> Ben, would patches like this be considered bugfixes as far as merging
> goes, or would they be for next given that it's something that's never
> really worked right and hasn't been touched in years?

Since they don't affect anything outside of 8xx, I'm happy to take them
until around -rc2 or 3. But it's your call really.

Cheers,
Ben.


