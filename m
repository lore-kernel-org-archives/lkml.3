Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab3AZNfR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 08:35:17 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:64380 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab3AZNfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 08:35:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 15/19] sunrpc: don't warn for unused variable 'buf'
Date: Sat, 26 Jan 2013 13:34:56 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-1-generic; KDE/4.3.2; x86_64; ; )
Cc: "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "J. Bruce Fields" <bfields@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de> <201301252345.25829.arnd@arndb.de> <20130126110321.GE23505@n2100.arm.linux.org.uk>
In-Reply-To: <20130126110321.GE23505@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301261334.56398.arnd@arndb.de>
X-Provags-ID: V02:K0:E8ZQQ3gQp5BE+KmdAlkOfygRpIbIoR1GLBxEcZDCBro
 HZ2Nx/1CQhfBeaLgvzG3vvjrCFdgikDr1gvAajruPpqX1sIc9G
 vKhUyGhST+K1TlTiWSAcqMJ7tDRDu+yIMEcEEUZZYF/WHXZuYc
 Kv/Z0k4RHUSY6TXbUFDPwcC00oR1Zuvs0w2Wi/jlBpZRweWXTM
 xq2Os6pwYmL0nkt7ozRtVJIeqi87Z5KNCf6ObJCS9RBFkQlBBo
 NtjY/b0LjZBWZwbYR7T3rsIBQGcCSnD3O0sZuuJGbw16f7vo0P
 cq+qYpbsz08gbT8FCEtOEK36XgCnQah31pnDaSeI/OLook4cQ4
 +l6hQCxc8YjH+UKK/oeM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 January 2013, Russell King - ARM Linux wrote:
> On Fri, Jan 25, 2013 at 11:45:25PM +0000, Arnd Bergmann wrote:
> > On Friday 25 January 2013, Myklebust, Trond wrote:
> > > > -----Original Message-----
> > > > From: Arnd Bergmann [mailto:arnd@arndb.de]
> > > > Marking it as __maybe_unused avoids a harmless gcc warning.
> > > 
> > > Alternatively, just declare it using the RPC_IFDEBUG() macro.
> > 
> > Right, makes sense: that's more consistent with other functions
> > doing the same thing. Thanks for taking a look.
> 
> NAK.
> 
> There is already a fix queued up as a result of a previous report I
> sent, but for some reason (which I didn't question) it was decided
> not to queue it for -rc.
> 
> See Bruce's reply on lkml: 20130108212816.GA24572@fieldses.org

Ok, makes sense. Then again, if that fix is queued for 3.9, maybe
it still makes sense to take the simpler fix into 3.8, and remove
it in 3.9 along with the other instances of RPC_IFDEBUG.

	Arnd
