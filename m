Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab3JAGNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 02:13:31 -0400
Received: from ozlabs.org ([203.10.76.45]:43157 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab3JAGNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 02:13:30 -0400
Date: Tue, 1 Oct 2013 16:13:25 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/legacy_serial: fix incorrect placement of
 __initdata tag
Message-ID: <20131001061325.GD17966@concordia>
References: <35419229.o6Cv8JYbpg@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35419229.o6Cv8JYbpg@amdc1032>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 03:11:42PM +0200, Bartlomiej Zolnierkiewicz wrote:
> __initdata tag should be placed between the variable name and equal
> sign for the variable to be placed in the intended .init.data section.

I see lots of other occurences of that in arch/powerpc. Why not send a
single patch to update them all?

cheers
