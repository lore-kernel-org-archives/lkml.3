Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbaDFQNG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 12:13:06 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48921 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753480AbaDFQNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 12:13:04 -0400
X-Sasl-enc: Ap2ac1dbJZ5hVm/dHu064HqkIGiGKA9GLIyL7A8VN8e1 1396800782
Date: Sun, 6 Apr 2014 09:15:31 -0700
From: Greg KH <greg@kroah.com>
To: Gmail <camille.bordignon@gmail.com>
Cc: "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "rashika.kheria@gmail.com" <rashika.kheria@gmail.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 1/1] staging: sep: Fix coding style
Message-ID: <20140406161531.GB1195@kroah.com>
References: <1396799011.1468.12.camel@vash.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396799011.1468.12.camel@vash.home>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, Apr 06, 2014 at 05:43:31PM +0200, Gmail wrote:

Your "From" line above doesn't match up with your "Signed-off-by:" line
down below :(

> This fixes coding style warning "Missing a blank line after
> declarations" in files sep_dev.h and sep_crypto.c (linux-next).
> 
> Sorry for the previous mail, tabs all got converted into spaces due to
> gmail webclient ... (thanks Greg).

This should go below the "---" line.

> 
> Signed-off-by: Camille Bordignon <camille.bordignon@gmail.com>
> ---

Care to try it a third time to get it in a format I can apply it?

thanks,

greg k-h
