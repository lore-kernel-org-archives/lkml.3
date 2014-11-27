Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbaK0QvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:51:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaK0QvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:51:17 -0500
Date: Thu, 27 Nov 2014 08:49:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL 00/25] phy: for 3.19
Message-ID: <20141127164955.GA13928@kroah.com>
References: <1417069577-1169-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417069577-1169-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 11:55:52AM +0530, Kishon Vijay Abraham I wrote:
> Hi Greg,
> 
> Please find the pull request for 3.19 merge window.
> 
> This contains improvements in phy core dealing with non-dt boot.
> It also adds 3 new phy drivers armada375-usb2, berlin-usb and miphy28lp.
> 
> There is a patch that touches drivers/pinctrl since one of the PHY drivers
> is present there and it has to be modified to use the modified
> devm_phy_create API.
> 
> Let me know If I have to change something.
> 
> Thanks
> Kishon
> 
> The following changes since commit 206c5f60a3d902bc4b56dab2de3e88de5eb06108:
> 
>   Linux 3.18-rc4 (2014-11-09 14:55:29 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git tags/for-3.19

Pulled and pushed out, thanks.

greg k-h
