Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbaFTUfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:35:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37448 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbaFTUfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:35:15 -0400
Date: Fri, 20 Jun 2014 22:35:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, Dave Jones <davej@redhat.com>
Subject: Re: [RFC][PATCH 3/3] x86: make MP  a required-feature on 64-bit
Message-ID: <20140620203507.GM11391@pd.tnic>
References: <20140620161740.BFB00798@viggo.jf.intel.com>
 <53A46008.5060509@zytor.com>
 <53A4619C.8020100@sr71.net>
 <53A46365.6090101@zytor.com>
 <20140620174345.GD11391@pd.tnic>
 <53A473AA.7050301@zytor.com>
 <20140620180523.GF11391@pd.tnic>
 <53A48356.5080109@zytor.com>
 <20140620200024.GJ11391@pd.tnic>
 <53A4981F.3060901@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53A4981F.3060901@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 01:22:55PM -0700, H. Peter Anvin wrote:
> Because the whole point is testing each CPU and warn if it is
> unsuitable.
>
> static-anything is just plain useless, because we test this once for
> each CPU and patching a branch that we are never going to cross again
> is just wasted effort.

Ah, I see. :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
