Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965486AbaFCRCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 13:02:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932931AbaFCRCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 13:02:05 -0400
Date: Tue, 3 Jun 2014 10:05:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Wolfram Sang <wolfram@the-dreams.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-i2c@vger.kernel.org
Subject: Re: i2c/ACPI: Support for multiple serial bus addresses
Message-ID: <20140603170543.GC22867@kroah.com>
References: <538DEF2A.7030506@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538DEF2A.7030506@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 08:52:10AM -0700, Srinivas Pandruvada wrote:
> Hi Greg,
> 
> If you get chance, please provide feedback. This will enable sensors in
> several new tablets and 2 in 1 laptops.
> 
> http://patchwork.ozlabs.org/patch/338342/
> http://patchwork.ozlabs.org/patch/338341/
> 
> If there is any other better way, then I can rework on this.

It's the middle of the kernel merge window, please come back with
"proposals" afterwards as I have no time to look at anything for a few
weeks.

greg k-h
