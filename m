Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab3FQXRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:17:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42189 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3FQXRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:17:33 -0400
Date: Mon, 17 Jun 2013 16:17:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org,
        Juan David Gonzalez Cobas <juan.david.gonzalez.cobas@cern.ch>,
        "Emilio G. Cota" <cota@braap.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/8] FMC: create drivers/fmc and toplevel Kconfig question
Message-ID: <20130617231732.GC12984@kroah.com>
References: <cover.1371018406.git.rubini@gnudd.com>
 <8dd3427d60e01c3e7a6eceb7dfd72d5a896b5008.1371018406.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8dd3427d60e01c3e7a6eceb7dfd72d5a896b5008.1371018406.git.rubini@gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 09:13:25AM +0200, Alessandro Rubini wrote:
> This commit creates the drivers/fmc directory and puts the necessary
> hooks for kbuild and kconfig.  The code is currently a placeholder
> that only registers an empty bus.
> 
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Juan David Gonzalez Cobas <dcobas@cern.ch>
> Acked-by: Emilio G. Cota <cota@braap.org>
> Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
> ---
>  MAINTAINERS            |    9 +++++++++
>  drivers/Kconfig        |    2 ++
>  drivers/Makefile       |    1 +
>  drivers/fmc/Kconfig    |   17 +++++++++++++++++
>  drivers/fmc/Makefile   |    4 ++++
>  drivers/fmc/fmc-core.c |   24 ++++++++++++++++++++++++
>  6 files changed, 57 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/fmc/Kconfig
>  create mode 100644 drivers/fmc/Makefile
>  create mode 100644 drivers/fmc/fmc-core.c

{sigh}

If only all patch submissions started out this way, my life would be so
nice and comfy, I could just blindly accept new subsystems knowing that
the submitter understood the development process and how to break things
up properly...

Nice job :)

Want me to take this through my char/misc git tree to get to Linus for
3.11?

thanks,

greg k-h
