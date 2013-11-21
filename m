Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab3KURaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 12:30:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47273 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab3KURaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 12:30:04 -0500
Date: Thu, 21 Nov 2013 09:30:02 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Leann Ogasawara <leann.ogasawara@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Next Long Term Stable?
Message-ID: <20131121173002.GB21986@kroah.com>
References: <CAAE8-rJ3SyKCD8BXphCE5d42p1pf1EW5e7ngnuJZ17VpbnMP5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAE8-rJ3SyKCD8BXphCE5d42p1pf1EW5e7ngnuJZ17VpbnMP5Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 03:42:26PM -0800, Leann Ogasawara wrote:
> Hi Greg,
> 
> I realize it's likely too early to even be inquiring about the next
> Longterm Stable kernel you'd be selecting to maintain, especially
> since you've recently selected the v3.10 kernel.  However, I thought
> it wouldn't hurt to at least mention that Ubuntu will anticipate
> shipping a v3.13 based kernel for the upcoming Ubuntu 14.04 LTS
> release happening in April 2014.  If it were possible, I know the
> Ubuntu kernel engineers would be interested in aligning and
> contributing to the next Long Term Stable Kernel you choose.  At the
> very least, I hope this information gives you at least one extra data
> point for when you do select the next Longterm Stable kernel you plan
> to maintain.  Thanks again for all the stable support and maintenance.

Thanks for letting us know, but given that I have stated numerous times
that I can not maintain 3 longterm stable kernels at the same time, and
if you look at the published supported schedule at:
	https://www.kernel.org/category/releases.html
it's going to be impossible for me to choose 3.13 as a longterm kernel,
sorry.

But best of luck with your LTS kernel, and if you find patches that are
applicable for 3.10, please feel free to send them to
stable@vger.kernel.org so that we can pick them up for that release as
well.

thanks,

greg k-h
