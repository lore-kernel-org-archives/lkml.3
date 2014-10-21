Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933854AbaJUVeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:34:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40782 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933458AbaJUVeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:34:03 -0400
Date: Wed, 22 Oct 2014 05:32:56 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "arm@kernel.org" <arm@kernel.org>,
        Bo Shen <voice.shen@atmel.com>, Mark Brown <broonie@kernel.org>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] MAINTAINERS: add atmel ssc driver maintainer entry
Message-ID: <20141021213256.GA27750@kroah.com>
References: <1411869439-2719-1-git-send-email-voice.shen@atmel.com>
 <54291A0C.3090206@atmel.com>
 <544672A6.9090101@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544672A6.9090101@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 04:50:14PM +0200, Nicolas Ferre wrote:
> On 29/09/2014 10:36, Nicolas Ferre :
> > On 28/09/2014 03:57, Bo Shen :
> >> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> > 
> > Sure:
> > Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > 
> > Thanks.
> 
> Greg or Arnd,
> 
> This MAINTAINER's update didn't make it during merge window (on the
> other hand, I didn't build a pull-request with it neither...).
> 
> Do you want that I take it in one of my "fixes" pull-requests to arm-soc
> for 3.18 or do you feel like taking the patch directly? I think it makes
> sense to not wait for the 3.19 for this kind of useful information.

Feel free to take it in one of your "fixes" pull requests.

thanks,

greg k-h
