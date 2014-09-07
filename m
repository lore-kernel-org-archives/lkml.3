Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaIGUwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 16:52:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:35885 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaIGUwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 16:52:11 -0400
Message-ID: <540CC574.4080203@infradead.org>
Date: Sun, 07 Sep 2014 13:52:04 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Peter Foley <pefoley2@pefoley.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 1/4] Documentation: use subdir-y to avoid unnecessary
 built-in.o files
References: <53FB9DA0.7000301@infradead.org> <CAOFdcFP4b0YFMuUFKm4=FoAGbCObf4u=W0UUPwf-ju_TNvuJaA@mail.gmail.com> <540651B3.8030400@infradead.org> <20140902232906.GG29327@sirena.org.uk> <CAOFdcFPmHH9z+6Kuc5Agu6PDC9+t+420Cb5R6VuHp+MebG+2LQ@mail.gmail.com> <20140903232149.GG29327@sirena.org.uk> <5407A68F.5090805@infradead.org> <20140904104201.GI29327@sirena.org.uk> <540A503D.20807@infradead.org> <540C9D19.5080201@infradead.org> <20140907184837.GD4015@sirena.org.uk>
In-Reply-To: <20140907184837.GD4015@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/14 11:48, Mark Brown wrote:
> On Sun, Sep 07, 2014 at 10:59:53AM -0700, Randy Dunlap wrote:
> 
>> The quilt-import.log from 20140829 says:
> 
>> $ git am --patch-format=mbox ../quilt/rd-docs/001-docum-use-subdiry-avoid-builtin.patch
> 
>> and in the 20140905 git tree it says:
> 
>> $ git am ../quilt/rd-docs/001-docum-use-subdiry-avoid-builtin.patch
>> Patch format detection failed.
> 
>> Are you using Stephen's scripts?  Why would his tree apply patches with
>> --patch-format=mbox
>> while the later trees did not use that git-am option?
> 
> Yes, I'm using his scripts.  I guess it's possible there's something in
> his global git configuration that changes the behaviour?

I can't find any such animal.  Hopefully Stephen can provide some insight
into this.

thanks,
-- 
~Randy
