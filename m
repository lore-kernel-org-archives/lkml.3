Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbbANWTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 17:19:43 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:55998 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbbANWTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 17:19:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        davem@davemloft.net, deller@gmx.de, egtvedt@samfundet.no,
        geert@linux-m68k.org, james.hogan@imgtec.com, jcmvbkbc@gmail.com,
        realmz6@gmail.com, sam@ravnborg.org, tglx@linutronix.de,
        will.deacon@arm.com
Subject: Re: [PULL] uaccess: fix sparse warning on get/put_user for bitwise types
Date: Wed, 14 Jan 2015 23:19:14 +0100
Message-ID: <5209009.XRo9cTX8bb@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150114173618.GA12436@redhat.com>
References: <20150114173618.GA12436@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:a+5/ow0wNxmVcdi0wZNF0l158XJaOAWD7DNgC422ZFWWVAFYbpK
 INIC+JQouM859gjKhIxnrxrhjz2EI2+FxSSKX9GqfnJ10P8oLAe15uK8oDbGSPRmUbkDWuS
 EdS1K9a6HSTYooSD00KMdupdDaVDtXyZfXwdT0GNPEEawmTOmYZnp+gcpsKfjzss1TW4KkD
 z0QJbjzLm4TkO6V+kfFkA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 January 2015 19:36:18 Michael S. Tsirkin wrote:
> As you asked, here's a pull request.
> This has been in linux-next apparently with no ill effects.
> 
> The following changes since commit 99975cc6ada0d5f2675e83abecae05aba5f437d2:
> 
>   vhost/net: length miscalculation (2015-01-07 12:22:00 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/uaccess_for_upstream
> 
> for you to fetch changes up to 0795cb1b46e7938ed679ccd48f933e75272b30e3:
> 

Pulled into my asm-generic now, thanks!

	Arnd
