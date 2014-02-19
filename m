Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbaBSLpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 06:45:50 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:32856 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaBSLpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 06:45:49 -0500
Date: Wed, 19 Feb 2014 11:45:29 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Valdis.Kletnieks@vt.edu
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kay.sievers@vrfy.org,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [PATCH 0/2] Fix missing misc nodes
Message-ID: <20140219114529.6a838d0e@alan.etchedpixels.co.uk>
In-Reply-To: <9687.1392774991@turing-police.cc.vt.edu>
References: <1392701245-4645-1-git-send-email-lucas.demarchi@intel.com>
	<9687.1392774991@turing-police.cc.vt.edu>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Feb 2014 20:56:31 -0500
Valdis.Kletnieks@vt.edu wrote:

> On Tue, 18 Feb 2014 02:27:23 -0300, Lucas De Marchi said:
> 
> > These patches are not intended for merging as is... clearly we have at least
> > one problem: fram's minor is clashing with logibm's. I don't know what to do
> > here.
> 
> They both look like obscure devices to me. Are there any architectures where
> both devices could conceivably exist on the same system at the same time?
> If not, it may not be a problem at all...

Which is how we got into multiple previous messes with device clashes.
Better to do it right, even better would be to fix the need for them to
be static nodes in the first place.

Alan
