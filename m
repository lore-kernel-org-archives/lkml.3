Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab3LKCBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 21:01:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42100 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab3LKCA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 21:00:59 -0500
Date: Tue, 10 Dec 2013 18:02:29 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3.4 01/25] crypto: scatterwalk - Set the chain pointer
 indication bit
Message-ID: <20131211020229.GB15638@kroah.com>
References: <20131210075930.808460227@linuxfoundation.org>
 <20131210075930.917877325@linuxfoundation.org>
 <986457BC66A4884EBFFDEFEBEB20F84C0B1EBBAA@satlexdag04.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <986457BC66A4884EBFFDEFEBEB20F84C0B1EBBAA@satlexdag04.amd.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 02:46:46PM +0000, Lendacky, Thomas wrote:
> Hi Greg,
> 
> This patch is probably not needed in any of the stable branches, but if
> you do add it you'll need to also include a patch that changes the use
> of an sg_page to an sg_chain_ptr to prevent a BUG_ON when CONFIG_DEBUG_SG
> is enabled (http://marc.info/?l=linux-crypto-vger&m=138627061905651&w=2).

You are referring to commit 389a5390583a18e45bc4abd4439291abec5e7a63 in
Linus's tree, right?  It's in my queue to apply after 3.13-rc4 comes
out, but I guess it's good to add it now as it is known that this is an
issue to be resolved.

I'll go do that right now, thanks for letting me know.

greg k-h
