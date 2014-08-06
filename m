Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbaHFTSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:18:40 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:61713 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516AbaHFTSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:18:38 -0400
Date: Wed, 6 Aug 2014 12:18:34 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: David Wood <david@dtwood.co.uk>
Cc: Nick Krause <xerofoiffy@gmail.com>, Mark Brown <broonie@kernel.org>,
        "open list:SPI SUBSYSTEM" <linux-spi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [PATCH] spi: Fix warning about redefinition
Message-ID: <20140806191834.GA12488@roeck-us.net>
References: <CAO+Sx3nGKN1jh0VB9NjcFCqV7ZmWWjJge0nohdUGta9BF60EWQ@mail.gmail.com>
 <20140806190412.GA5605@roeck-us.net>
 <CAO+Sx3ncSgmdQq-PyZwXzN-ZJJ+0VD+kNVNJYzir+mHzVwxbdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO+Sx3ncSgmdQq-PyZwXzN-ZJJ+0VD+kNVNJYzir+mHzVwxbdw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 09:07:04PM +0200, David Wood wrote:
> On 6 August 2014 21:04, Guenter Roeck <linux@roeck-us.net> wrote:
> > On Wed, Aug 06, 2014 at 08:53:41PM +0200, David Wood wrote:
> > ...
> > That was purely to ensure that there is no hidden use through a macro
> > defined elsewhere, not a suggestion for a real patch.
> >
> > Guenter
> 
> I also managed not to notice that I had in fact shown that the fs.h
> definitions were the opposite of those in the spi driver, so it would
> in fact be significant if they were swapped.
> 
See it positively: There is someone out there doing an excellent job
of forcing various kernel maintainers to have a close look into areas
of the kernel they would otherwise never look at. In addition to that,
we all gain valuable knowledge on how to validate patches.

Guenter
