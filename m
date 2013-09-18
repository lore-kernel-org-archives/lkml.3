Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab3IRMxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:53:50 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:52651 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab3IRMxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:53:49 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19o+DERPn6nz9/bBZDs6Z05AyqkqzfG4gA=
Date: Wed, 18 Sep 2013 08:53:42 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: linux-next stats (Was: Linux 3.12-rc1)
Message-ID: <20130918125342.GK19937@titan.lakedaemon.net>
References: <CA+55aFxg-WropC74v5ir5r9kBJKEd93fgye4oTBhw5T8e8sb+g@mail.gmail.com>
 <20130917155057.2125aa5f69fb9cf9bbe01166@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130917155057.2125aa5f69fb9cf9bbe01166@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

On Tue, Sep 17, 2013 at 03:50:57PM +1000, Stephen Rothwell wrote:
> There are also 358 commits in next-20130701 that didn't make it into v3.11-rc1.
> 
> Top ten first word of commit summary:
> 
>      56 arm
> 
> Top ten authors:
> 
>      13 Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> 
> Top ten commiters:
> 
>      22 Jason Cooper <jason@lakedaemon.net>

:(  That's my mistake.  I should've been tracking my pull requests to
arm-soc more closely.  We've already tweaked the process to prevent this
in the future.

thx,

Jason.
