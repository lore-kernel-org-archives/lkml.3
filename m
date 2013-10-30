Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab3J3RfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:35:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46845 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab3J3RfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:35:22 -0400
Date: Wed, 30 Oct 2013 10:35:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        Frank Haverkamp <haver@vnet.ibm.com>
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver (v4)
Message-ID: <20131030173521.GB20147@kroah.com>
References: <1383125578-26202-1-git-send-email-haver@linux.vnet.ibm.com>
 <1383125578-26202-2-git-send-email-haver@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383125578-26202-2-git-send-email-haver@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 10:32:58AM +0100, Frank Haverkamp wrote:
> +if GENWQE
> +
> +config GENWQE_DEVNAME
> +        string "Name for sysfs and device nodes"
> +	default "genwqe"
> +        help
> +          Select alternate name for sysfs and device nodes.

Don't let the user pick this, it's up to the driver to set this once and
then live with it.

And, from what I can tell in the driver, this help text is wrong (there
are no device nodes with this name in it, right?)

thanks,

greg k-h
