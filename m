Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab3JHD4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 23:56:32 -0400
Received: from ozlabs.org ([203.10.76.45]:55400 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630Ab3JHD4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 23:56:31 -0400
Date: Tue, 8 Oct 2013 14:56:23 +1100
From: Michael Ellerman <michael@ellerman.id.au>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/legacy_serial: fix incorrect placement of
 __initdata tag
Message-ID: <20131008035623.GA31666@concordia>
References: <35419229.o6Cv8JYbpg@amdc1032>
 <20131001061325.GD17966@concordia>
 <1600459.LJx7sBeEJs@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600459.LJx7sBeEJs@amdc1032>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 01:51:27PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Tuesday, October 01, 2013 04:13:25 PM Michael Ellerman wrote:
> > On Mon, Sep 30, 2013 at 03:11:42PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > __initdata tag should be placed between the variable name and equal
> > > sign for the variable to be placed in the intended .init.data section.
> > 
> > I see lots of other occurences of that in arch/powerpc. Why not send a
> > single patch to update them all?
> 
> The other occurences while not following the preferred kernel coding style
> are (probably) working OK with gcc. This particular occurence just doesn't
> work as it should.

Why would the other occurrences work but not this one?

Regardless, why don't we just do a single patch to clean them all up to
match coding style and (probably) do what they're intended.

cheers
