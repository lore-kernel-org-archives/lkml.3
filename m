Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab3FRQDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:03:01 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:41285 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932555Ab3FRQC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:02:59 -0400
X-Sasl-enc: CzU7AoirvsBiHAnEri/Vh3+FfKM0i477z9OQnSarfLC4 1371571377
Date: Tue, 18 Jun 2013 09:03:33 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bernd Bassimir <bassimir.kernel@gmx.de>,
        Nico Doerr <nico.doerr@hawo.net>
Subject: Re: linux-next: manual merge of the staging tree with the usb tree
Message-ID: <20130618160333.GC28961@kroah.com>
References: <20130618145559.cc7923dac280e736c908a422@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618145559.cc7923dac280e736c908a422@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 02:55:59PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/serqt_usb2/serqt_usb2.c between commit 1143832eca8f
> ("USB: serial: ports: add minor and port number") from the usb tree and
> commit d68edc2881b1 ("staging: serqt_usb2: Fixed coding style
> CamelCases") from the staging tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Fix looks fine, thanks.

greg k-h
