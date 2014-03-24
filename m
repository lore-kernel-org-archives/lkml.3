Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaCXEd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 00:33:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaCXEd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 00:33:26 -0400
Date: Sun, 23 Mar 2014 21:34:59 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Patrick Lai <plai@codeaurora.org>
Subject: Re: [PATCH 3.10 56/85] ASoC: pcm: free path list before exiting from
 error conditions
Message-ID: <20140324043459.GC6471@kroah.com>
References: <20140321000558.606667505@linuxfoundation.org>
 <20140321000606.724570655@linuxfoundation.org>
 <20140322185547.GB30031@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140322185547.GB30031@sirena.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2014 at 06:55:47PM +0000, Mark Brown wrote:
> On Thu, Mar 20, 2014 at 05:09:59PM -0700, Greg Kroah-Hartman wrote:
> > 3.10-stable review patch.  If anyone has any objections, please let me know.
> 
> Ben noticed an issue with this when checking for v3.13, I've dropped
> from upstream.

Thanks, now dropped from the stable tree too.

greg k-h
