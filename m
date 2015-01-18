Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbbARASD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 19:18:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbbARASB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 19:18:01 -0500
Date: Sat, 17 Jan 2015 16:09:14 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-fbdev@vger.kernel.org,
        Sudip Mukherjee <sudip@vectorindia.org>,
        Teddy Wang <teddy.wang@siliconmotion.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Revert "staging: sm7xxfb: remove driver"
Message-ID: <20150118000914.GA26160@kroah.com>
References: <1420028805-30488-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420028805-30488-1-git-send-email-sudipm.mukherjee@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 05:56:43PM +0530, Sudip Mukherjee wrote:
> This reverts commit "dc93c85235efa5201e9a3c116bc3fbd1afc1a182"
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
> 
> Hi Greg K-H
> With reference to our discussion at https://lkml.org/lkml/2014/11/22/54 ,
> now I have the hardware and I will be working on the code along with
> Teddy Wang.

I'm not going to accept this revert until I see some cleanup / fix
patches as well, so please make a larger series with the revert and then
some work done to the driver, so I at least have a hint it's not
abandonded.

thanks,

greg k-h
