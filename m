Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965042Ab3E2IDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 04:03:10 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58092 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964850Ab3E2IDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 04:03:05 -0400
X-Sasl-enc: YLudWgM0hoFqAQSDwr7zZJ7dkt3RRcIAfbFDJgT3uSHw 1369814583
Date: Wed, 29 May 2013 17:03:21 +0900
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org,
        =?utf-8?B?IlTDvGxpbiDEsHplciI=?= <tulinizer@gmail.com>
Subject: Re: linux-next: manual merge of the staging tree with the net-next
 tree
Message-ID: <20130529080320.GA2961@kroah.com>
References: <20130529141422.f0ce7703d21d02b9d2543930@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130529141422.f0ce7703d21d02b9d2543930@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 02:14:22PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/silicom/bpctl_mod.c between commit 351638e7deee ("net:
> pass info struct via netdevice notifier") from the net-next tree and
> commit f84b075178b4 ("Staging: silicom: Fixed error 'do not initialise
> statics to 0 or NULL'") from the staging tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

The fix looks great, thanks.

greg k-h
