Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab3CCV0d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 16:26:33 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:36041 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab3CCV0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 16:26:32 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 3 Mar 2013 22:26:16 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH 14/14] MAINTAINERS: use same pattern for firewire in
 uapi
Message-ID: <20130303222616.6e902a51@stein>
In-Reply-To: <1362275632-20242-15-git-send-email-cesarb@cesarb.net>
References: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
	<1362275632-20242-15-git-send-email-cesarb@cesarb.net>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 02 Cesar Eduardo Barros wrote:
> This avoids a false positive in the checkmaintainers.py script.
[...]
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3236,7 +3236,7 @@ W:	http://ieee1394.wiki.kernel.org/
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git
>  S:	Maintained
>  F:	drivers/firewire/
> -F:	include/linux/firewire.h
> +F:	include/linux/firewire*.h
>  F:	include/uapi/linux/firewire*.h
>  F:	tools/firewire/
>  

I prefer "include/linux/firewire.h".
-- 
Stefan Richter
-=====-===-= --== ---==
http://arcgraph.de/sr/
