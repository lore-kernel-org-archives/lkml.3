Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762032AbbA1UtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:49:25 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:61901 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759361AbbA1UtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:49:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Smack: fix netfilter Makefile entry
Date: Wed, 28 Jan 2015 17:29:07 +0100
Message-ID: <1767230.5ujIMaZVYc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54C90DE8.1030600@schaufler-ca.com>
References: <2504358.ZeqdfUXKpJ@wuerfel> <54C90DE8.1030600@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:ygrjlXsNrLXMLfqC0OJHtXdtiZ3GF3C5f38RSIXXtJ5yMikd16b
 eCG4sWe02nHu9xXM4aWUhGDAYwRqYQku9XVOXvuH6iChJlBoQtXh9k7QAVZopU/7g70IKso
 dCbnV12N0IewngRWpKxW2heYDZCTVENiw4J1TQMlS8cmLUDCmpBD6DMDHMC31fK3lgx1dQe
 oOOdgsmnzf5LsnZzPSdOg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 January 2015 08:27:20 Casey Schaufler wrote:
> On 1/28/2015 8:12 AM, Arnd Bergmann wrote:
> > The newly added Smack support for netfilter secmark has its own
> > Kconfig symbol, but the actual implementation is conditionally
> > built on another symbol.
> 
> A patch for this problem, 82b0b2c2b1e64ad6c5309a9eeba806af9812666b
> is already available in:
> 
> 	git://git.gitorious.org/smack-next/kernel.git smack-for-3.20-rebased
> 
> A pull request has sent to James Morris for inclusion in the security tree.

Ok, thanks!

	Arnd
