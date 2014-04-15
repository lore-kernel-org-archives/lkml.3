Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaDODay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 23:30:54 -0400
Received: from tundra.namei.org ([65.99.196.166]:48967 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbaDODax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 23:30:53 -0400
Date: Tue, 15 Apr 2014 13:36:53 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Joe Perches <joe@perches.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next 3.16 19/19] security: Convert use of typedef
 ctl_table to struct ctl_table
In-Reply-To: <4104b157fcc0867b2348c364556a5a44da2a0324.1397438826.git.joe@perches.com>
Message-ID: <alpine.LRH.2.02.1404151336410.5781@tundra.namei.org>
References: <cover.1397438826.git.joe@perches.com> <4104b157fcc0867b2348c364556a5a44da2a0324.1397438826.git.joe@perches.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2014, Joe Perches wrote:

> This typedef is unnecessary and should just be removed.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  security/keys/sysctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next

-- 
James Morris
<jmorris@namei.org>
