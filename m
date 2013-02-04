Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab3BDE5E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 23:57:04 -0500
Received: from mail.kernel.org ([198.145.19.201]:51073 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771Ab3BDE5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 23:57:02 -0500
Date: Sun, 3 Feb 2013 20:59:14 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 net-next tree
Message-ID: <20130204045914.GA16842@kroah.com>
References: <20130204153831.083f30730888d66d4f83acd3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204153831.083f30730888d66d4f83acd3@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 03:38:31PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in drivers/net/wan/Kconfig between commit a786a7c0ad44 ("wanrouter: completely decouple obsolete code from kernel") from the net-next tree and commit c9f1b39aee74 ("drivers/net/wan: remove depends on CONFIG_EXPERIMENTAL") from the driver-core tree.
> 
> The former removed part of the text changed by the latter, so I just did
> that (see below) and can carry the fix as necessary (no action is
> required).

That sounds fine to me, thanks.

greg k-h
