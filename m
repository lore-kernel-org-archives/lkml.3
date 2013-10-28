Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab3J1PXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:23:19 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46632 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757019Ab3J1PXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 11:23:17 -0400
Date: Mon, 28 Oct 2013 16:23:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
        tigran@aivazian.fsnet.co.uk, x86@kernel.org, andi@firstfloor.org
Subject: Re: [PATCH] x86, microcode, Fix long microcode load time when
 firmware file is missing [v2]
Message-ID: <20131028152314.GN4314@pd.tnic>
References: <1382961968-20067-1-git-send-email-prarit@redhat.com>
 <20131028143714.GL4314@pd.tnic>
 <20131028150656.GA15440@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131028150656.GA15440@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 01:06:56PM -0200, Henrique de Moraes Holschuh wrote:
> AMD can get away with a half-done implementation of negative caching
> (or an "optimised one" depending on your PoV :) ) because they have
> per-family firmware files, so even mixed-stepping systems will require
> only the same file. This is *not* true for Intel, which is really
> annoying.

Not per family but per-a-couple-of-families and starting with F15h we
did a separate container because of some obscure reason we had to dance
around at the time.

But per-family is enough because I hardly doubt any x86 vendor
would do mixed-setups of CPUs from different families. It is called
mixed-steppings for a reason: you can mix the same family and model CPUs
but with different steppings. And I think AMD had a K8 system which
sported that.

Mixing different families (and models for that matter) would be pretty
PITA and you're better off simply buying a bunch of identical CPUs :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
