Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab3JWOwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 10:52:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46488 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab3JWOwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 10:52:40 -0400
Date: Wed, 23 Oct 2013 15:54:11 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: Michal Marek <mmarek@suse.cz>, Frank Haverkamp <haver@vnet.ibm.com>,
        linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, jsvogt@de.ibm.com,
        MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com, michael@ibmra.de
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver
Message-ID: <20131023145411.GA3411@kroah.com>
References: <1374740897-20304-1-git-send-email-haver@vnet.ibm.com>
 <1374740897-20304-2-git-send-email-haver@vnet.ibm.com>
 <51F12668.8000400@suse.cz>
 <1382534154.2791.8.camel@oc7383187364.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382534154.2791.8.camel@oc7383187364.ibm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 03:15:54PM +0200, Frank Haverkamp wrote:
> Hi Marek,
> 
> it took a little while, but here are the requested changes to our
> driver:
> 
> Rework comments:
>  o Removed __DATE__ macros as suggested by Michal Marek
> 
> Plus some little things we found during test and review:
>  o Removed some obsolete comments
>  o Fixed a bug in the initialization path when
>    genwqe_set_interrupt_capability() fails

The patch is line-wrapped and can not be applied at all, please work to
fix your email client :(

greg k-h
