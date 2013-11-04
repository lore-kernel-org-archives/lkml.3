Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab3KDWKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 17:10:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48734 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab3KDWKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 17:10:34 -0500
Date: Mon, 4 Nov 2013 14:12:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de
Subject: Re: [PATCH 1/9] Generic WorkQueue Engine (GenWQE) device driver (v4)
Message-ID: <20131104221246.GC14141@kroah.com>
References: <1383584889-21594-1-git-send-email-haver@linux.vnet.ibm.com>
 <1383584889-21594-2-git-send-email-haver@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383584889-21594-2-git-send-email-haver@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 06:08:01PM +0100, Frank Haverkamp wrote:
> +if GENWQE
> +
> +config GENWQE_DEVNAME
> +        string "Name for sysfs and device nodes"
> +	default "genwqe"
> +        help
> +          Select alternate name for sysfs and device nodes.
> +
> +endif

Why is this still here?  I thought you said you had removed this?

