Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760025Ab3BMQgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:36:48 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:37757 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759377Ab3BMQgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:36:47 -0500
Date: Wed, 13 Feb 2013 08:36:44 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH 4/9] extcon: max8997: Move defined constant to header file
Message-ID: <20130213163644.GA28986@kroah.com>
References: <1360748110-21909-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360748110-21909-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 06:35:10PM +0900, Chanwoo Choi wrote:
> This patch move defined constants to header file(max77693-private.h)
> because of mask/unmask selectively interrupt of MUIC device according
> to attribute of H/W board.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> ---
>  drivers/extcon/extcon-max8997.c     | 92 +++++++++++++------------------------
>  include/linux/mfd/max8997-private.h | 49 ++++++++++++++++++++
>  2 files changed, 80 insertions(+), 61 deletions(-)

This patch fails to apply, so I stopped here in the series.  Feel free
to redo this and resend the rest once you fix this up.

thanks,

greg k-h
