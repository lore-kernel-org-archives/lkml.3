Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaJFMpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 08:45:23 -0400
Received: from tundra.namei.org ([65.99.196.166]:50376 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbaJFMpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 08:45:21 -0400
Date: Mon, 6 Oct 2014 23:44:57 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: Dmitry Kasatkin <d.kasatkin@samsung.com>, zohar@linux.vnet.ibm.com,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, rusty@rustcorp.com.au,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Subject: Re: [PATCH 3/4] module: search the key only by keyid
In-Reply-To: <13201.1412343605@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.11.1410062344070.24016@namei.org>
References: <542E9FE8.2070009@samsung.com> <6d32cecfb3c3f5d041900ce1866bc15134832991.1412327306.git.d.kasatkin@samsung.com> <cover.1412327306.git.d.kasatkin@samsung.com> <cover.1412327306.git.d.kasatkin@samsung.com> <29146.1412340378@warthog.procyon.org.uk>
 <542E9B68.1010906@samsung.com> <542E9C65.4030208@samsung.com> <13201.1412343605@warthog.procyon.org.uk>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2014, David Howells wrote:

> Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:
> 
> > BTW. But actually why signer is needed to find the key?
> > Every key has unique fingerprint.
> 
> The SKID is by no means guaranteed unique, is not mandatory and has no defined
> algorithm for generating it.
> 
> > Or you say that different certificates might have the same PK?
> > What I would consider strange. But anyway, if PK is the same, then
> > verification succeed.
> 
> Do note: We *do* need to get away from using SKIDs.  We have situations where
> we have to use a key that doesn't have one.
> 

David, I need to push to Linus for 3.17 -- please finalize the fix for 
this and send me a pull request.



-- 
James Morris
<jmorris@namei.org>

