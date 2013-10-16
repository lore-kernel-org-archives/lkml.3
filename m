Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761969Ab3JPURh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:17:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37185 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761940Ab3JPURg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:17:36 -0400
Date: Wed, 16 Oct 2013 13:17:35 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
        linux@arm.linux.org.uk
Subject: Re: [PATCH 27/28] serial: sh: use DMA_COMPLETE for dma completion
 status
Message-ID: <20131016201735.GA28441@kroah.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
 <1381940926-25564-28-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381940926-25564-28-git-send-email-vinod.koul@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 09:58:45PM +0530, Vinod Koul wrote:
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> Greg, pls ack this as it has depedency on my tree

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
