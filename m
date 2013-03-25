Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab3CYMek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 08:34:40 -0400
Received: from mail-pa0-f65.google.com ([209.85.220.65]:52616 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757038Ab3CYMeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 08:34:37 -0400
Date: Mon, 25 Mar 2013 20:34:27 +0800 (CST)
From: Xiong Zhou <jencce.kernel@gmail.com>
X-X-Sender: zx@M2420
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Xiong Zhou <jencce.kernel@gmail.com>, linux-next@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: Re: [patch] sound/soc/codec : fix build failure in next-201303225
In-Reply-To: <20130325120601.GN18316@opensource.wolfsonmicro.com>
Message-ID: <alpine.DEB.2.02.1303252017020.20514@M2420>
References: <alpine.DEB.2.02.1303251950440.20514@M2420> <20130325120601.GN18316@opensource.wolfsonmicro.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 25 Mar 2013, Mark Brown wrote:

> On Mon, Mar 25, 2013 at 07:59:43PM +0800, Xiong Zhou wrote:
> 
> > -const char *arizona_rate_text[ARIZONA_RATE_ENUM_SIZE] = {
> > -	"SYNCCLK rate", "8kHz", "16kHz", "ASYNCCLK rate",
> > -};
> > +extern const char *arizona_rate_text[ARIZONA_RATE_ENUM_SIZE];
> >  EXPORT_SYMBOL_GPL(arizona_rate_text);
> 
> No, this isn't a good fix at all - we're moving the array to the header
> but still exporting it from this file which is not clever at all.  The
> user should be conditional.
> 

Yes, I agree with you much. Do you have some plan with this array? 
The exproting seems not necesary right now, How about just moving 
the array to the header?
