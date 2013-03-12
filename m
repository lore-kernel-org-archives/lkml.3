Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763Ab3CLWVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:21:38 -0400
Received: from mail-ia0-f179.google.com ([209.85.210.179]:38343 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab3CLWVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:21:36 -0400
Date: Tue, 12 Mar 2013 15:21:32 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux-Next <linux-next@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [-next] staging/comedi regressions
Message-ID: <20130312222132.GA12477@kroah.com>
References: <CAMuHMdXyBqwqn3aWpjwer5HYYqQvyMJTxJY-WeDGxLxkg_ZXQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdXyBqwqn3aWpjwer5HYYqQvyMJTxJY-WeDGxLxkg_ZXQw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 11:13:50PM +0100, Geert Uytterhoeven wrote:
> m68k/allmodconfig:
> 
> drivers/staging/comedi/drivers/ni_atmio.c: In function ‘ni_isapnp_find_board’:
> drivers/staging/comedi/drivers/ni_atmio.c:353: error: ‘n_ni_boards’
> undeclared (first use in this function)
> drivers/staging/comedi/drivers/ni_atmio.c:353: error: (Each undeclared
> identifier is reported only once
> drivers/staging/comedi/drivers/ni_atmio.c:353: error: for each
> function it appears in.)
> drivers/staging/comedi/drivers/ni_atmio.c: In function ‘ni_getboardtype’:
> drivers/staging/comedi/drivers/ni_atmio.c:391: error: ‘n_ni_boards’
> undeclared (first use in this function)
> drivers/staging/comedi/drivers/ni_atmio.c: In function ‘ni_atmio_attach’:
> drivers/staging/comedi/drivers/ni_atmio.c:470: error: ‘boardtype’
> undeclared (first use in this function)
> 
> http://kisskb.ellerman.id.au/kisskb/buildresult/8392062/

Hartley already fixed it, this will show up in the next linux-next tree
as I commited the fix a few hours ago.

thanks,

greg k-h
