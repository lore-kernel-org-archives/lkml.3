Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbaJGE61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 00:58:27 -0400
Received: from tundra.namei.org ([65.99.196.166]:50385 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbaJGE6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 00:58:25 -0400
Date: Tue, 7 Oct 2014 15:58:15 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: d.kasatkin@samsung.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] KEYS: 
In-Reply-To: <4792.1412616356@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.11.1410071557590.7306@namei.org>
References: <4792.1412616356@warthog.procyon.org.uk>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2014, David Howells wrote:

> Hi James,
> 
> Can you pull these fixes into your next branch?
> 
>  (1) Handle error codes in pointers correctly so as not to crash.
> 
>  (2) Fix the asymmetric key description to make module signature checking work
>      right (I changed the description to include the X.509 serial number, but
>      the module uses the subjectKeyId still).
> 
>  (3) Bring back matching of keys based on partial matches on the auxiliary
>      IDs (required for IMA).
> 
>  (4) Make the PGP fingerprint field in /proc/keys hold the tail end of the
>      SKID once again (if present).
> 
>  (5) IMA needs to zero-pad the key ID it requests a match on because the hex
>      string will be rejected if it's not a multiple of two digits.
> 
> David
> ---
> The following changes since commit c867d07e3c861e75509650b8a359351d634db93a:
> 
>   Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity into next (2014-10-02 19:47:23 +1000)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/keys-next-fixes-20141006

Thanks, pulled.



-- 
James Morris
<jmorris@namei.org>

