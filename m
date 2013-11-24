Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab3KXWfc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 17:35:32 -0500
Received: from tundra.namei.org ([65.99.196.166]:54036 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165Ab3KXWfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 17:35:30 -0500
Date: Mon, 25 Nov 2013 09:44:51 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] ima: bug fixes for Linus
In-Reply-To: <1385306510.5186.7.camel@dhcp-9-2-203-236.watson.ibm.com>
Message-ID: <alpine.LRH.2.02.1311250943500.2259@tundra.namei.org>
References: <1385145621.9559.5.camel@dhcp-9-2-203-236.watson.ibm.com> <1385306510.5186.7.camel@dhcp-9-2-203-236.watson.ibm.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Nov 2013, Mimi Zohar wrote:

> Hi James,
> 
> Linus has already reverted the trusted keyring support for IMA patches.
> These patches are re-based on -rc1.
> 
> The following changes since commit 4c1cc40a2d49500d84038ff751bc6cd183e729b5:
> 
>   Revert "KEYS: verify a certificate is signed by a 'trusted' key" (2013-11-23 16:38:17 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity for-linus
> 
> for you to fetch changes up to 3eeb2d63ab623be55bb2ff584e123c0df45691e3:
> 
>   ima: make a copy of template_fmt in template_desc_init_fields() (2013-11-24 00:29:23 -0500)
> 

I don't understand -- are these all fixes for regressions in the new 
kernel?


-- 
James Morris
<jmorris@namei.org>
