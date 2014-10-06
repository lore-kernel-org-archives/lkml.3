Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaJFTj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 15:39:57 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:55361 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaJFTjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 15:39:55 -0400
Message-ID: <1412624388.7773.10.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 3/4] module: search the key only by keyid
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: David Howells <dhowells@redhat.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, rusty@rustcorp.com.au,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Date: Mon, 06 Oct 2014 15:39:48 -0400
In-Reply-To: <alpine.LRH.2.11.1410062344070.24016@namei.org>
References: <542E9FE8.2070009@samsung.com>
	 <6d32cecfb3c3f5d041900ce1866bc15134832991.1412327306.git.d.kasatkin@samsung.com>
	 <cover.1412327306.git.d.kasatkin@samsung.com>
	 <cover.1412327306.git.d.kasatkin@samsung.com>
	 <29146.1412340378@warthog.procyon.org.uk> <542E9B68.1010906@samsung.com>
	 <542E9C65.4030208@samsung.com> <13201.1412343605@warthog.procyon.org.uk>
	 <alpine.LRH.2.11.1410062344070.24016@namei.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100619-3532-0000-0000-000005320F21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-06 at 23:44 +1100, James Morris wrote: 
> On Fri, 3 Oct 2014, David Howells wrote:
> 
> > Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:
> > 
> > > BTW. But actually why signer is needed to find the key?
> > > Every key has unique fingerprint.
> > 
> > The SKID is by no means guaranteed unique, is not mandatory and has no defined
> > algorithm for generating it.
> > 
> > > Or you say that different certificates might have the same PK?
> > > What I would consider strange. But anyway, if PK is the same, then
> > > verification succeed.
> > 
> > Do note: We *do* need to get away from using SKIDs.  We have situations where
> > we have to use a key that doesn't have one.
> > 
> 
> David, I need to push to Linus for 3.17 -- please finalize the fix for 
> this and send me a pull request.

Thanks Dmitry, David.  Everything now seems to be working properly with
the patchset David posted today.

Mimi 

