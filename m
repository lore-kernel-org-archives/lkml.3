Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab3FKHwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 03:52:23 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:57325 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab3FKHwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 03:52:22 -0400
Date: Tue, 11 Jun 2013 00:52:26 -0700
From: Olof Johansson <olof@lixom.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Tang <dt.tangr@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org
Subject: Re: [PATCH] Add Initial TI-Nspire support
Message-ID: <20130611075226.GA15718@quad.lixom.net>
References: <E775DD08-5516-468E-9924-0D839218D7F9@gmail.com>
 <201306071955.26375.arnd@arndb.de>
 <9C5E608F-2DA8-469E-8C7C-B678B5EFC68B@gmail.com>
 <1464231.JBtC8Grrsg@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1464231.JBtC8Grrsg@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 08, 2013 at 07:46:28PM +0200, Arnd Bergmann wrote:
> On Saturday 08 June 2013 11:42:54 Daniel Tang wrote:
> > 
> > On 08/06/2013, at 3:55 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > If it hasn't been merged yet, would it be possible for me to
> > send version 2 of the patches? Or would you rather I wait
> > until it is merged and send in a separate patch to fix them?
> 
> Either way works fine, only after it has been merged into arm-soc
> you should send add-on patches rather than replacements.

Please feel free to repost a new version, I'll hold off applying until then.

Most pending pull request should have been made, please remind me if it looks
like something is missing. What I need to go back and spend a bit more time on
is review of some of the new platforms, as well as making sure that some of the
"smaller" platforms where maintainers don't have their own git repos don't have
any outstanding patch series that need to be applied -- I think there are
a couple.

I'll look at those tomorrow and we should be all caught up.


-Olof
