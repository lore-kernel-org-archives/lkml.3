Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab3JXKIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 06:08:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60356 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab3JXKII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 06:08:08 -0400
Date: Thu, 24 Oct 2013 11:09:42 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, jsvogt@de.ibm.com,
        MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com, michael@ibmra.de
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver v2
Message-ID: <20131024100942.GA13614@kroah.com>
References: <1382544921-17012-1-git-send-email-haver@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382544921-17012-1-git-send-email-haver@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 06:15:21PM +0200, Frank Haverkamp wrote:
> Rework comments:
>  o Removed __DATE__ macros as suggested by Michal Marek
>  o Removed startup pr_info() as suggested by Greg KH
> 
> Plus some little things we found during test and review:
>  o Removed some obsolete comments
>  o Fixed a bug in the initialization path when
>    genwqe_set_interrupt_capability() fails
> 
> Greg, I tried my luck now with git send-email. Please let
> me know if that works better.

That's one of the the worst commit message that I've ever seen, you
really want this as the thing that shows up in the git commit log?

I have no idea what this code is, what it does, nor what it should do.

Also, you are using sysfs, but have no Documetation/ABI/ modifications,
which isn't allowed.

I need a whole more information before I can even start to review the
code to try to determine if it's ok or not.

greg k-h
