Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbaKFXED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:04:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55782 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbaKFXD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 18:03:59 -0500
Date: Thu, 6 Nov 2014 15:03:58 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: kris@konagma.com
Cc: navin.patidar@gmail.com, Larry Finger <Larry.Finger@lwfinger.net>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtl8188eu: Fix several stylistic problems in rtw_led.*
Message-ID: <20141106230358.GA12437@kroah.com>
References: <1415314565-9552-1-git-send-email-kris@konagma.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415314565-9552-1-git-send-email-kris@konagma.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 11:56:05PM +0100, kris@konagma.com wrote:
> From: Krzysztof Konopko <kris@konagma.com>
> 
> Several stylistics problems are reported by scripts/checkpatch.pl run on
> rtw_led.*:
> 
>   * FSF_MAILING_ADDRESS
> 
>     Free Software Foundation's mailing address should not be included in
>     the sample GPL notice.
> 
>   * LINE_SPACING
> 
>     Missing a blank line after declarations.
> 
>   * leading spaces
> 
>   * a typo
> 
>   * any too long lines changed with this patch
> 
> All of the problems above are fixed with this patch.

Each patch should only do 1 thing, so please break this up into multiple
patches, each only doing 1 thing, in a patch series, and resend so it
can be applied.

thanks,

greg k-h
