Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab3HVRXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 13:23:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab3HVRXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 13:23:04 -0400
Date: Thu, 22 Aug 2013 10:23:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [RFC/RFT 00/33] Add new staging driver for RTL8188EU
Message-ID: <20130822172302.GA23442@kroah.com>
References: <1377142455-9204-1-git-send-email-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377142455-9204-1-git-send-email-Larry.Finger@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 10:33:42PM -0500, Larry Finger wrote:
> Initially, the only Linux driver for the RTL8188EU chips incorporated
> in devices such as the TP-Link TL-WN725N was one sent to me privately
> by the Realtek engineers with permission to submit it to the Linux kernel.
> Not only did it have limited availability, this version fails to build on
> kernels 3.10 and newer.
> 
> As an initial step, I fixed the Realtek version to build on all kernels,
> and submitted that code to http://github.com/lwfinger/rtl8188eu.git.
> This fixed the build and availability problems; however, the problems
> associated with building an out-of-kernel driver remain. During the past
> few months, I converted the code into a form suitable for Linux, and
> pushed those changes to that repo. I now believe it is time to submit
> it to drivers/staging.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Looks good enough to me, now applied, thanks for doing this work!

greg k-h
