Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751135AbaEAEqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 00:46:12 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40236 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757AbaEAEqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 00:46:11 -0400
X-Sasl-enc: Y49ylyMsyGkD1GG67V2+ghAYGiezBRzyzswDtLxFPhDR 1398919569
Date: Wed, 30 Apr 2014 21:47:07 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Jonathan Cameron <jic23@kernel.org>, Jean Delvare <jdelvare@suse.de>
Subject: Re: linux-next: manual merge of the staging tree with the
 staging.current tree
Message-ID: <20140501044707.GB6918@kroah.com>
References: <20140501143726.13b4ea03f25679d3e0a78fed@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140501143726.13b4ea03f25679d3e0a78fed@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 02:37:26PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/iio/adc/Kconfig between commit bbc28134e915 ("iio: adc: Nothing
> in ADC should be a bool CONFIG") from the staging.current tree and commit
> 9ef080ec0c5e ("iio: adc: Fix exynos_adc dependencies") from the staging
> tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, thanks.

greg k-h
