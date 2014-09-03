Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934583AbaICXjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:39:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:42853 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933390AbaICXjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 19:39:00 -0400
Message-ID: <5407A68F.5090805@infradead.org>
Date: Wed, 03 Sep 2014 16:38:55 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Peter Foley <pefoley2@pefoley.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/4] Documentation: use subdir-y to avoid unnecessary
 built-in.o files
References: <1397743910-18391-1-git-send-email-pefoley2@pefoley.com> <53FB9DA0.7000301@infradead.org> <CAOFdcFP4b0YFMuUFKm4=FoAGbCObf4u=W0UUPwf-ju_TNvuJaA@mail.gmail.com> <540651B3.8030400@infradead.org> <20140902232906.GG29327@sirena.org.uk> <CAOFdcFPmHH9z+6Kuc5Agu6PDC9+t+420Cb5R6VuHp+MebG+2LQ@mail.gmail.com> <20140903232149.GG29327@sirena.org.uk>
In-Reply-To: <20140903232149.GG29327@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/14 16:21, Mark Brown wrote:
> On Wed, Sep 03, 2014 at 07:08:38PM -0400, Peter Foley wrote:
>> On Tue, Sep 2, 2014 at 7:29 PM, Mark Brown <broonie@kernel.org> wrote:
>>> Your tree either wasn't in the control file that Stephen handed off or
>>> got eaten by one off his scripts for some reason.  I've tried adding it
>>> back, we'll see if that works tomorrow.
> 
>> The patches still seem to be missing from the 20140903 -next tree,
>> unfortunately.
> 
> The update is not happening because:
> 
> | git am ../quilt/rd-docs/001-docum-use-subdiry-avoid-builtin.patch
> | Patch format detection failed.
> 
> I guess either something changed in the way Randy is generating his
> patches or I'm using a different version of git which doesn't like
> them - looking at te patch files I'm not *entirely* surprised they 
> have trouble.
> 

Hm, it could be a problem with the Index line.  I'll disable that option
in quilt and see if that helps for the next time.

Thanks.

-- 
~Randy
