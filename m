Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206Ab3J2QBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:01:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35735 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab3J2QBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:01:49 -0400
Date: Tue, 29 Oct 2013 09:01:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kevin McKinney <klmckinney1@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com
Subject: Re: [PATCH 02/11 V2] Staging: bcm: Remove typedef for _U_IP_ADDRESS
 and call directly.
Message-ID: <20131029160148.GA20656@kroah.com>
References: <1383018708-29615-1-git-send-email-klmckinney1@gmail.com>
 <1383018708-29615-3-git-send-email-klmckinney1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383018708-29615-3-git-send-email-klmckinney1@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 11:51:39PM -0400, Kevin McKinney wrote:
> This patch removes typedef for _U_IP_ADDRESS, and
> changes the name of the struct to bcm_ip_address. In
> addition, any calls to struct "U_IP_ADDRESS" are
> changed to call directly.
> 
> Signed-off-by: Kevin McKinney <klmckinney1@gmail.com>

Someone already sent me a patch that did much the same thing so your
patch no longer applied :(

greg k-h
