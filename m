Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbaIHV0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 17:26:10 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:46994 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbaIHV0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 17:26:08 -0400
Date: Tue, 9 Sep 2014 00:26:01 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Nitin Kuppelur <nitinkuppelur@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: octeon-hcd: removed unwanted return from void
 functions
Message-ID: <20140908212601.GB10550@drone.musicnaut.iki.fi>
References: <1410196395-4595-1-git-send-email-nitinkuppelur@gmail.com>
 <20140908185923.GA10550@drone.musicnaut.iki.fi>
 <20140908193347.GA13636@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908193347.GA13636@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 08, 2014 at 12:33:47PM -0700, Greg KH wrote:
> On Mon, Sep 08, 2014 at 09:59:23PM +0300, Aaro Koskinen wrote:
> > On Mon, Sep 08, 2014 at 07:13:15PM +0200, Nitin Kuppelur wrote:
> > > This is a patch to the octeon-hcd.c file that fixes checkpatch.pl warning by removing return statement from void functions.
> > 
> > Please format line length to <= 76 characters in the commit log.
> > 
> > Maybe you could fix __cvmx_usb_perform_complete() as well?
> 
> What is wrong with it?  That should be in a separate patch...

There's "return;" at the end of void function. I thought the patch
was about that, however it seems checkpatch.pl does not seem
complain about that.

A.
