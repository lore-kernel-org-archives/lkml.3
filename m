Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaEUUjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 16:39:54 -0400
Received: from longford.logfs.org ([213.229.74.203]:43367 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaEUUjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 16:39:53 -0400
Date: Wed, 21 May 2014 16:38:11 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: mix all saved registers into entropy pool
Message-ID: <20140521203811.GB30084@logfs.org>
References: <20140519211719.GA14563@logfs.org>
 <8761l0r6nc.fsf@tassilo.jf.intel.com>
 <20140520200803.GA22308@logfs.org>
 <20140521193905.GN1873@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140521193905.GN1873@two.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2014 21:39:05 +0200, Andi Kleen wrote:
> 
> > I think leaking of private keys or similar information is not a
> > concern.  But please prove me wrong.  Better you now than someone else
> > later.
> 
> While I don't have a concrete exploit it seems seems dangerous to me. 
> The LibreSSL people just removed a similar behavior from OpenSSL.

Btw, if your concern were justified, that would also speak volumes
about the quality of our random generator - with or without my patch.
Either you are wrong or we have a real problem on our hands already.

Jörn

--
This above all: to thine own self be true.
-- Shakespeare
