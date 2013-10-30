Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3J3Wit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:38:49 -0400
Received: from tundra.namei.org ([65.99.196.166]:57363 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848Ab3J3Wir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:38:47 -0400
Date: Thu, 31 Oct 2013 09:43:07 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: John Johansen <john.johansen@canonical.com>
cc: SECURITY SUBSYSTEM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PULL] apparmor: changes for 3.13
In-Reply-To: <5271793C.4070003@canonical.com>
Message-ID: <alpine.LRH.2.02.1310310942100.9718@tundra.namei.org>
References: <5271793C.4070003@canonical.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Oct 2013, John Johansen wrote:

> Hey James,
> 
> could you please pull the following apparmor patches for 3.13. There is
> nothing new here just a couple audit path cleanups that lead up to Oleg's
> cleanyp of current ptrace_parent.
> 
> The following changes since commit 50b719f811583a47762ecb7e480d253abc2eb22f:
> 
>   Merge branch 'smack-for-3.13' of git://git.gitorious.org/smack-next/kernel into ra-next (2013-10-30 14:07:10 +1100)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jj/linux-apparmor.git for-security
> 

Thanks, pulled.  You're cutting it a bit close to the Linus release -- try 
for -rc4 or so.  The work for the next kernel should be ready by then.

 


-- 
James Morris
<jmorris@namei.org>
