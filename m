Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab3JNPRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:17:19 -0400
Received: from tundra.namei.org ([65.99.196.166]:34126 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756663Ab3JNPRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:17:17 -0400
Date: Tue, 15 Oct 2013 02:20:51 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: John Johansen <john.johansen@canonical.com>
cc: SECURITY SUBSYSTEM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: Re: apparmor: two more regression fixes for 3.12
In-Reply-To: <525906EE.90409@canonical.com>
Message-ID: <alpine.LRH.2.02.1310150220160.6053@tundra.namei.org>
References: <525906EE.90409@canonical.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Oct 2013, John Johansen wrote:

> Hi James,
> 
>   Can you please pull and forward the following 2 fixes for regressions in
>   3.12 apparmor
> 
> thanks
> john
> 
> ---
> 
> The following changes since commit 94ecad0c9ca2c9345013d2417081cea7cf842c16:
> 
>   apparmor: fix suspicious RCU usage warning in policy.c/policy.h (2013-09-29 08:28:11 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jj/linux-apparmor security-next
> 
> for you to fetch changes up to dcb08d624b002693bed8ca6bf0456e09b4a90028:
> 
>   apparmor: fix bad lock balance when introspecting policy (2013-10-11 18:43:16 -0700)
> 
> ----------------------------------------------------------------
> John Johansen (2):
>       apparmor: fix memleak of the profile hash
>       apparmor: fix bad lock balance when introspecting policy
> 

Can you email me the patches?  I need to apply them to current Linus.



-- 
James Morris
<jmorris@namei.org>
