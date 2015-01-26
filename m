Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbbAZKtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:49:41 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:44714 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbbAZKtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:49:39 -0500
Date: Mon, 26 Jan 2015 10:49:36 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Jon Masters <jonathan@jonmasters.org>, Laszlo Ersek <lersek@redhat.com>,
        Dave Young <dyoung@redhat.com>, linux-efi <linux-efi@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Shorten efi regions output
Message-ID: <20150126104936.GB3320@codeblueprint.co.uk>
References: <20141209095843.GA3990@pd.tnic>
 <20141210021741.GA3280@darkstar.nay.redhat.com>
 <20141210104627.GA17053@pd.tnic>
 <20150105140332.GB3163@console-pimps.org>
 <54AAA723.1070605@redhat.com>
 <54BF3DCA.4070708@jonmasters.org>
 <20150121100633.GC12173@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150121100633.GC12173@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan, at 11:06:33AM, Borislav Petkov wrote:
> On Wed, Jan 21, 2015 at 12:48:58AM -0500, Jon Masters wrote:
> > We have on a number of occasions found just this output useful in
> > debugging boot issues on ARM servers
> 
> We can turn it on by default on ARM and off on x86...

Yeah, there's no reason we need to have the same default. That is to
say, it can be on for ARM and off for x86, but when enabled the format
should be the same for both.

In the future the memory maps are likely to contain even more entries
and I suspect we're going to get more requests to disable the voluminous
memmap output by default if we don't do so now.

-- 
Matt Fleming, Intel Open Source Technology Center
