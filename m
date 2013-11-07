Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab3KGHer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 02:34:47 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:34367 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab3KGHem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 02:34:42 -0500
Date: Thu, 7 Nov 2013 08:34:38 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: kernel bugzilla #64531: intel microcode information
Message-ID: <20131107073438.GA26654@gmail.com>
References: <527B28BB.9070400@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527B28BB.9070400@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <rdunlap@infradead.org> wrote:

> Re: https://bugzilla.kernel.org/show_bug.cgi?id=64531
> 
> 
> arch/x86/Kconfig line 1053 (+/-), help section in CONFIG_MICROCODE_INTEL, says:
> 
> For latest news and information on obtaining all the required
> Intel ingredients for this driver, check:
> <http://www.urbanmyth.org/microcode/>
> 
> ==> 404  Page not found
> 
> 
> Is there a good replacement for this information or should we just
> delete that help text?

I'd say let's delete the text. Mind sending a patch?

Thanks,

	Ingo
