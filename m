Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933887AbaFCRDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 13:03:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932714AbaFCRDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 13:03:20 -0400
Date: Tue, 3 Jun 2014 10:06:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Wolfram Sang <wolfram@the-dreams.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-i2c@vger.kernel.org
Subject: Re: i2c/ACPI: Support for multiple serial bus addresses
Message-ID: <20140603170659.GD22867@kroah.com>
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

Wait, this is i2c stuff, why would I care about this?

confused,

greg k-h
