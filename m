Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaETBEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 21:04:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51163 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbaETBEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 21:04:35 -0400
Date: Tue, 20 May 2014 10:04:15 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        sarah.a.sharp@linux.intel.com
Subject: Re: [PATCH 00/10] xhci: features for usb-next
Message-ID: <20140520010414.GA20035@kroah.com>
References: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 07:25:53PM +0300, Mathias Nyman wrote:
> Hi Greg
> 
> These following xhci patches are for usb-next and hopefully for 3.16
> 
> This patcheseries includes a bigger change in xhci command queue code,
> (last four patches), a task that I've been working on for a longer time.
> Sarah gave green light for v5 before she went on her sabbatical.
> 
> http://marc.info/?l=linux-usb&m=139889908701592&w=2

I've applied 9 of these.

thanks,

greg k-h
