Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbaJNIkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 04:40:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39216 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaJNIkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 04:40:00 -0400
Date: Tue, 14 Oct 2014 10:38:54 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Cristian Stoica <cristian.stoica@freescale.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3.14 36/37] crypto: caam - fix addressing of struct member
Message-ID: <20141014083854.GB3141@kroah.com>
References: <20141013022400.286360067@linuxfoundation.org>
 <20141013022401.796709337@linuxfoundation.org>
 <543CDF7C.4080209@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543CDF7C.4080209@freescale.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 11:31:56AM +0300, Cristian Stoica wrote:
> Hi Greg,
> 
> You can cherry-pick 307fd543f3d23f8f56850eca1b27b1be2fe71017 on stable
> 3.13+ as well. The original 'cc stable 3.13+' line was deleted by
> mistake during commit.

3.13-stable is long dead and not being maintained by me anymore, sorry.

greg k-h
