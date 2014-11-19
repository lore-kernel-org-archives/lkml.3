Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbaKSSrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 13:47:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731AbaKSSrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 13:47:40 -0500
Date: Wed, 19 Nov 2014 10:47:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Peter Hung <hpeter@gmail.com>
Cc: jslaby@suse.cz, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix IO address calculation with Multi-Fintek PCI-to-UART
 Product
Message-ID: <20141119184739.GA28871@kroah.com>
References: <1416304088-6049-1-git-send-email-hpeter+linux_kernel@gmail.com>
 <20141118165800.GA3708@kroah.com>
 <546C2DCC.4090507@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546C2DCC.4090507@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 01:42:36PM +0800, Peter Hung wrote:
> Dear Greg KH and Senior Linuxers,
> 
> I had some some question, If I submited a patch, but it had rejected, how
> should I do when fix the patch?
> 
> 1. send patch by reply original email ?

You can do this, with a [PATCH v2] in the subject.

> 2. direct send patch with new email again?

That works as well, but tell us what changed from the first one please.

thanks,

greg k-h
