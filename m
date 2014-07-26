Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaGZA0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 20:26:53 -0400
Received: from tundra.namei.org ([65.99.196.166]:34146 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbaGZA0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 20:26:51 -0400
Date: Sat, 26 Jul 2014 10:26:27 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: sfr@canb.auug.org.au, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        mimi.e.zohar@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>,
        vgoyal@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Keyrings: PKCS#7 fixup
In-Reply-To: <22574.1406291448@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.11.1407261026160.7832@namei.org>
References: <22574.1406291448@warthog.procyon.org.uk>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2014, David Howells wrote:

> Hi James,
> 
> Here's a fixup for the problem that Stephen spotted.
> 
> David
> ---
> The following changes since commit 633706a2ee81637be37b6bc02c5336950cc163b5:
> 
>   Merge branch 'keys-fixes' into keys-next (2014-07-22 21:55:45 +0100)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/keys-next-20140725
> 
> for you to fetch changes up to 8f3438ccea149647ad1849651d1e14c7b8b85e63:
> 
>   PKCS#7: Missing inclusion of linux/err.h (2014-07-25 11:33:53 +0100)

Thanks, pulled.


-- 
James Morris
<jmorris@namei.org>

