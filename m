Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbaIFAHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 20:07:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:56515 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbaIFAHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 20:07:32 -0400
Message-ID: <540A503D.20807@infradead.org>
Date: Fri, 05 Sep 2014 17:07:25 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Peter Foley <pefoley2@pefoley.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 1/4] Documentation: use subdir-y to avoid unnecessary
 built-in.o files
References: <1397743910-18391-1-git-send-email-pefoley2@pefoley.com> <53FB9DA0.7000301@infradead.org> <CAOFdcFP4b0YFMuUFKm4=FoAGbCObf4u=W0UUPwf-ju_TNvuJaA@mail.gmail.com> <540651B3.8030400@infradead.org> <20140902232906.GG29327@sirena.org.uk> <CAOFdcFPmHH9z+6Kuc5Agu6PDC9+t+420Cb5R6VuHp+MebG+2LQ@mail.gmail.com> <20140903232149.GG29327@sirena.org.uk> <5407A68F.5090805@infradead.org> <20140904104201.GI29327@sirena.org.uk>
In-Reply-To: <20140904104201.GI29327@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/14 03:42, Mark Brown wrote:
> On Wed, Sep 03, 2014 at 04:38:55PM -0700, Randy Dunlap wrote:
> 
>> Hm, it could be a problem with the Index line.  I'll disable that option
>> in quilt and see if that helps for the next time.
> 
> Still seems to be happening today I'm afraid.
> 

I tested using git-am.  Yes, that fails.  These patch files are not emails
but git-am expects emails and fails when it cannot find email headers (AFAICT).

Using git-apply instead of git-am does apply these patches.

-- 
~Randy
