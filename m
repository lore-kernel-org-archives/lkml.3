Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbaJPJME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:12:04 -0400
Received: from ou.quest-ce.net ([195.154.187.82]:40044 "EHLO ou.quest-ce.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbaJPJMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:12:02 -0400
Message-ID: <1413450624.17854.3.camel@localhost.localdomain>
From: Yann Droneaud <ydroneaud@opteya.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Jeremy Kerr <jk@ozlabs.org>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <trivial@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>
Date: Thu, 16 Oct 2014 11:10:24 +0200
In-Reply-To: <1413251832.21120.4.camel@concordia>
References: <cover.1413223900.git.ydroneaud@opteya.com>
	 <9a145561123e28585d7994b61359a531128a80b8.1413223900.git.ydroneaud@opteya.com>
	 <1413251832.21120.4.camel@concordia>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 37.161.179.118
X-SA-Exim-Mail-From: ydroneaud@opteya.com
Subject: Re: [PATCHv9 2/5] ppc/cell: trivial: replace get_unused_fd() by
 get_unused_fd_flags(0)
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on ou.quest-ce.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le mardi 14 octobre 2014 à 12:57 +1100, Michael Ellerman a écrit :
> On Mon, 2014-10-13 at 21:30 +0200, Yann Droneaud wrote:
> > This patch replaces calls to get_unused_fd() with equivalent call to
> > get_unused_fd_flags(0) to preserve current behavor for existing code.
> > 
> > In a further patch, get_unused_fd() will be removed so that new code
> > start using get_unused_fd_flags(), with the hope O_CLOEXEC could be
> > used, either by default or choosen by userspace.
> > 
> > Link: http://lkml.kernel.org/r/cover.1413223900.git.ydroneaud@opteya.com
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: trivial@kernel.org
> > Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
> 
> This is fine by me, do you want an ack, or do you want us to take it via the
> powerpc tree?
> 

The patch was added in -mm by Andrew, so I guess the patch will be
merged sooner or later.

Anyway, you could investigate to check if O_CLOEXEC could be used
instead of 0 in call to get_unused_fd_flags().

> If the former:
> 
> Acked-by: Michael Ellerman <mpe@ellerman.id.au>
> 

Thanks a lot.

Regards.

-- 
Yann Droneaud
OPTEYA


