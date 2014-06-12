Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbaFLR02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:26:28 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:39982 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbaFLR01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:26:27 -0400
Date: Thu, 12 Jun 2014 10:26:20 -0700
From: josh@joshtriplett.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Documentation: exceptions to what I maintain
Message-ID: <20140612172620.GA21930@cloud>
References: <5399DF99.2010701@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5399DF99.2010701@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 10:12:57AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Note that I don't maintain Documentation/ABI/,
> Documentation/devicetree/, or the language translation files.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

One comment below.

>  MAINTAINERS |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- lnx-315-rc5.orig/MAINTAINERS
> +++ lnx-315-rc5/MAINTAINERS
> @@ -2885,7 +2885,7 @@ M:	Randy Dunlap <rdunlap@infradead.org>
>  L:	linux-doc@vger.kernel.org
>  T:	quilt http://www.infradead.org/~rdunlap/Doc/patches/
>  S:	Maintained
> -F:	Documentation/
> +F:	Documentation/ (but not: ABI, devicetree, translations)

Could we make this machine-readable, and teach scripts/get_maintainer.pl
to understand it?  Two possible syntaxes:

F: Documentation/
F: !Documentation/ABI/
...

or:

F: Documentation/ (not Documentation/ABI ...)
