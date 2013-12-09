Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760912Ab3LIIgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:36:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48279 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab3LIIg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:36:29 -0500
Date: Mon, 9 Dec 2013 00:33:17 -0800
From: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 31/39] USB: remove DEFINE_PCI_DEVICE_TABLE macro
Message-ID: <20131209083317.GA27716@kroah.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
 <003401ceefb6$22c930e0$685b92a0$%han@samsung.com>
 <20131209040342.GA20608@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131209040342.GA20608@saruman.home>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 08, 2013 at 10:03:42PM -0600, Felipe Balbi wrote:
> On Tue, Dec 03, 2013 at 08:27:58AM +0900, Jingoo Han wrote:
> > Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
> > is not preferred.
> > 
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> 
> I wonder why I wasn't Cc:ed to this email considering it touches three
> drivers I care about.
> 
> Greg, I have the original ones in my tree and I would really like to
> avoid rebasing my 'next' branch. Do we keep it there or do you want to
> avoid merging those commits ?

Just keep it there and we can handle the merge, it shouldn't be a big
deal, right?

thanks,

greg k-h
