Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab3CCFvr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 00:51:47 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:54643 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750806Ab3CCFvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 00:51:46 -0500
Message-ID: <1362289904.2254.9.camel@joe-AO722>
Subject: Re: [PATCH 14/14] MAINTAINERS: use same pattern for firewire in uapi
From: Joe Perches <joe@perches.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net
Date: Sat, 02 Mar 2013 21:51:44 -0800
In-Reply-To: <1362275632-20242-15-git-send-email-cesarb@cesarb.net>
References: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
	 <1362275632-20242-15-git-send-email-cesarb@cesarb.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-02 at 22:53 -0300, Cesar Eduardo Barros wrote:
> This avoids a false positive in the checkmaintainers.py script.

You should fix the script instead of making
deliberate errors in MAINTAINERS.

> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -3236,7 +3236,7 @@ W:	http://ieee1394.wiki.kernel.org/
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git
>  S:	Maintained
>  F:	drivers/firewire/
> -F:	include/linux/firewire.h
> +F:	include/linux/firewire*.h




