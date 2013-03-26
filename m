Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035Ab3CZEMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 00:12:08 -0400
Received: from ozlabs.org ([203.10.76.45]:59920 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932815Ab3CZEMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 00:12:06 -0400
Date: Tue, 26 Mar 2013 15:12:01 +1100
From: Michael Ellerman <michael@ellerman.id.au>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: remove two lines of dead code
Message-ID: <20130326041201.GB22382@concordia>
References: <1364207531.1390.271.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364207531.1390.271.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 11:32:11AM +0100, Paul Bolle wrote:
> Commit c1fb6816fb1b78dd94b673b0fdaa9a7a16e97bd1 ("powerpc: Add
> relocation on exception vector handlers") added two lines of code that
> depend on the macro CONFIG_HVC_SCOM. That macro doesn't exist. Perhaps
> it was intended to use CONFIG_PPC_SCOM here. But since
> "maintence_interrupt" is a typo and there's nothing in arch/powerpc that
> looks like maintenance_interrupt it seems best to just delete these
> lines.

It's cruft from our internal tree that snuck into the patch. I was
meaning to remove it but you beat me to it.

Acked-by: Michael Ellerman <michael@ellerman.id.au>

cheers
