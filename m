Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559Ab3GKNyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:54:38 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57803 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932454Ab3GKNyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:54:36 -0400
Date: Thu, 11 Jul 2013 15:54:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: Konrad Vrba <konrad.vrba@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Error 2: No rule to make target kernel/timeconst.pl
Message-ID: <20130711135417.GC8900@pd.tnic>
References: <CAF2Nc0xVKS+aL0CXdDFQHSapvRxM35KZkjeKeigQ7X43+2NVBA@mail.gmail.com>
 <20130711104307.GB28131@pd.tnic>
 <CAF2Nc0xjxtWkpmurODWKNMCC9D+4Xf6gMnQAqAiec6zn4V0z3w@mail.gmail.com>
 <20130711123548.GA8900@pd.tnic>
 <CAF2Nc0ybnoQ7ZYoYzZNci4PaPnH5PA8--8-OBw4u0b3COT6tDQ@mail.gmail.com>
 <20130711131845.GB8900@pd.tnic>
 <CAF2Nc0yyLAmTmd6a0MDGALwKqnJ295A7Hfa45jDKq6r+EV0_1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAF2Nc0yyLAmTmd6a0MDGALwKqnJ295A7Hfa45jDKq6r+EV0_1A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 03:47:36PM +0200, Konrad Vrba wrote:
> You are right.
> I have now tried compiling on another machine, and that works fine.
> But I am using the same config and same kernel tar.xz
> that does not make sense

Can you restart from scratch on the first machine? Download a new
tar.xz, verify md5sums, unpack, add the config and build? Oh and delete
the old unpacked sources and downloaded tar.xz beforehand.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
