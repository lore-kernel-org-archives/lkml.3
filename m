Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbaGQTbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 15:31:49 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38506 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752418AbaGQTbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 15:31:47 -0400
X-Sasl-enc: XA+jmCGk9LF5yAcWzu00APBaBpKIGt6JzrgTvbrF9ha+ 1405625506
Date: Thu, 17 Jul 2014 12:31:45 -0700
From: Greg KH <greg@kroah.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
        linux-crypto@vger.kernel.org, beck@openbsd.org
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Message-ID: <20140717193145.GA4703@kroah.com>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405588695-12014-1-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 05:18:15AM -0400, Theodore Ts'o wrote:

Minor nit:

> @@ -469,6 +471,8 @@ static struct entropy_store nonblocking_pool = {
>  					push_to_pool),
>  };
>  
> +DECLARE_COMPLETION(urandom_initialized);
> +

static DECLARE_COMPLETION(urandom_initialized);

instead?

thanks,

greg k-h
