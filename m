Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaHJMLj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 08:11:39 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36505 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751464AbaHJMLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 08:11:34 -0400
X-Sasl-enc: pTJ1JKRsjVB5alH1+Kx1wT/t0BdIyJewrT0yqMV+ASl4 1407672691
Date: Sat, 9 Aug 2014 21:32:22 -0700
From: Greg KH <greg@kroah.com>
To: Srikrishan Malik <srikrishanmalik@gmail.com>
Cc: andreas.dilger@intel.com, oleg.drokin@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/12] staging: lustre: remove space between function
 name and and open parenthesis
Message-ID: <20140810043222.GA2648@kroah.com>
References: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 10:42:51PM +0530, Srikrishan Malik wrote:
> Fixes following checkpatch warning:
> 
> WARNING: space prohibited between function name and open parenthesis '('
> 
> Signed-off-by: Srikrishan Malik <srikrishanmalik@gmail.com>

Can you redo this whole series, based on the comments you have recieved?

thanks,

greg k-h
