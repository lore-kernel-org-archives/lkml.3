Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873Ab3CZQ3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:29:42 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:42438 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab3CZQ3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:29:41 -0400
Date: Tue, 26 Mar 2013 09:29:38 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [GIT PULL] extcon/ASoC: arizona: Fix interactions around HPDET
Message-ID: <20130326162938.GA8276@kroah.com>
References: <20130326154014.GD18316@opensource.wolfsonmicro.com>
 <20130326155812.GF18316@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130326155812.GF18316@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 03:58:13PM +0000, Mark Brown wrote:
> On Tue, Mar 26, 2013 at 03:40:14PM +0000, Mark Brown wrote:
> 
> > I've taken the liberty of pulling into ASoC already, if there's a
> > problem with that I can drop the changes easily enough.
> 
> While adding the ASoC stuff on top I realised that one of the
> overlapping changes should just be squashed down into the ASoC change
> here so I've gone ahead and done that and redone the tag, sorry about
> the noise.

No problem.  I've merged this to my char-misc.next branch so all should
be good.

thanks,

greg k-h
