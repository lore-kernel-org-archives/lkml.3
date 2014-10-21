Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001AbaJUOR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:17:57 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:57812 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711AbaJUORz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:17:55 -0400
Date: Tue, 21 Oct 2014 22:17:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Amos Kong <akong@redhat.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, m@bues.ch,
        mpm@selenic.com, amit.shah@redhat.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] hw_random: fix unregister race.
Message-ID: <20141021141745.GA18511@gondor.apana.org.au>
References: <1411043867-21109-1-git-send-email-akong@redhat.com>
 <1411043867-21109-5-git-send-email-akong@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411043867-21109-5-git-send-email-akong@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 08:37:45PM +0800, Amos Kong wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
> 
> The previous patch added one potential problem: we can still be
> reading from a hwrng when it's unregistered.  Add a wait for zero
> in the hwrng_unregister path.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

You totally corrupted Rusty's patch.  If you're going to repost
his series you better make sure that you've got the right patches.

Just as well though as it made me think a little more about this
patch :)

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
