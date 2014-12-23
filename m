Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbaLWAbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 19:31:36 -0500
Received: from ozlabs.org ([103.22.144.67]:57648 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbaLWAbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 19:31:35 -0500
Message-ID: <1419294690.30550.2.camel@ellerman.id.au>
Subject: Re: [PATCH] [TRIVIAL] IBM Akebono: Remove select of
 IBM_EMAC_RGMII_WOL
From: Michael Ellerman <mpe@ellerman.id.au>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jiri Kosina <trivial@kernel.org>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Alistair Popple <alistair@popple.id.au>
Date: Tue, 23 Dec 2014 11:31:30 +1100
In-Reply-To: <2224792.Nmvmc626jj@mexican>
References: <1415008333.20372.26.camel@x220>
	 <1419243273.30945.19.camel@x220> <2224792.Nmvmc626jj@mexican>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-23 at 09:48 +1100, Alistair Popple wrote:
> Hi Paul,
> 
> These days I've been made maintainer of the PPC4XX tree so maybe adding Acked-
> by: Alistair Popple <alistair@popple.id.au> might help?
> 
> Jiri, if you would rather this go via the main PPC tree please let us know and 
> we'll see if Michael Ellerman (added to CC) would be willing to take it (he 
> has taken over most of the day to day maintenance of the PPC tree). Thanks!

It never went to linuxppc as far as I can see, though I am happy to take it.
Although it is a trivial patch I'd still rather you CC'ed us on patches to
arch/powerpc.

cheers


