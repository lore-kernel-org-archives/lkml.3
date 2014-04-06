Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbaDFQk0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 12:40:26 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:47802 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754002AbaDFQkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 12:40:24 -0400
X-Sasl-enc: fDAPfN62V0mO1HaHAyD3bYB6jCXGADsxj99JmTYDMIc3 1396802423
Date: Sun, 6 Apr 2014 09:42:52 -0700
From: Greg KH <greg@kroah.com>
To: Camille Bordignon <camille.bordignon@gmail.com>
Cc: "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "rashika.kheria@gmail.com" <rashika.kheria@gmail.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 1/1] staging: sep: Fix coding style
Message-ID: <20140406164252.GA5737@kroah.com>
References: <1396801287.1468.18.camel@vash.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396801287.1468.18.camel@vash.home>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 06, 2014 at 06:21:27PM +0200, Camille Bordignon wrote:
> Signed-off-by: Camille Bordignon <camille.bordignon@gmail.com>
> ---
> Fix coding style warning "Missing a blank line after declarations"

No, this needs to go up above your signed-off-by:, it was the "fixed
after Greg's response" that could go below.

Don't worry about it, I'll edit this by hand when I apply it...

thanks,

greg k-h
