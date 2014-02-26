Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaBZUnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:43:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaBZUnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:43:49 -0500
Date: Wed, 26 Feb 2014 12:45:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, ak@linux.intel.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Subject: Re: Final: Add 32 bit VDSO time function support
Message-ID: <20140226204524.GA1598@kroah.com>
References: <1393443298.1917.5.camel@wall-e.seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393443298.1917.5.camel@wall-e.seibold.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 08:34:58PM +0100, Stefani Seibold wrote:
> Hi,
> 
> i still wait for ACK's for the  32 bit VDSO time function support. Whats
> the next step? Is there a way to apply it to the linux-git or linux-next
> in near future?

I thought this was already in the tip tree.  Didn't the emails saying
this happened come by a few days ago?  Or was it pulled from there for
some reason?

thanks,

greg k-h
