Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609Ab3FRRIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:08:55 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52096 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933339Ab3FRRIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:08:53 -0400
Date: Tue, 18 Jun 2013 19:08:48 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Subject: Re: [x86][v2] only print out DR registers if they are not power-on
 defaults.
Message-ID: <20130618170848.GD13114@pd.tnic>
References: <20130618041132.GA23492@redhat.com>
 <20130618084356.GA13123@pd.tnic>
 <20130618140730.GA1313@redhat.com>
 <20130618155919.GC13123@pd.tnic>
 <20130618160911.GA24487@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130618160911.GA24487@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 12:09:11PM -0400, Dave Jones wrote:
> The DR registers are rarely useful when decoding oopses.
> With screen real estate during oopses at a premium, we can save two lines
> by only printing out these registers when they are set to something other
> than they power-on state.
> 
> [v2: incorporate D6 change suggested by Borislav Petkov <bp@alien8.de>]
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
