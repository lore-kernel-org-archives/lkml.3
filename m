Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbaB1Wav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 17:30:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaB1Wau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 17:30:50 -0500
Date: Fri, 28 Feb 2014 14:32:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Chase Southwood <chase.southwood@yahoo.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        abbotti@mev.co.uk, dan.carpenter@oracle.com
Subject: Re: [PATCH 1/2 v2] Staging: comedi: fix lines that are over 80
 characters
Message-ID: <20140228223228.GA22295@kroah.com>
References: <1393572680-9521-1-git-send-email-chase.southwood@yahoo.com>
 <1393578945-20488-1-git-send-email-chase.southwood@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393578945-20488-1-git-send-email-chase.southwood@yahoo.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 03:15:45AM -0600, Chase Southwood wrote:
> This patch introduces a simple helper function, outl_1564_timer(), to
> allow several lines which violate the character limit to be shortened.
> A handful of other lines that are too long are appropriately split as
> well.
> 
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
> 2: introduced outl_1564_timer() at the suggestion of Dan.
>  .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 83 +++++++++++++---------
>  1 file changed, 49 insertions(+), 34 deletions(-)

The Subject: doesn't match the patch content :(

