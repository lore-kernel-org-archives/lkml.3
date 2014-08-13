Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbaHMWHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:07:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaHMWHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:07:35 -0400
Date: Thu, 14 Aug 2014 06:06:59 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: rbasukala <basukalaramesh@gmail.com>
Cc: lisa@xenapiadmin.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: bmc: fix coding style warning
Message-ID: <20140813220659.GG7908@kroah.com>
References: <1407944219-14614-1-git-send-email-basukalaramesh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407944219-14614-1-git-send-email-basukalaramesh@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 11:36:59AM -0400, rbasukala wrote:
> This a a patch to the vendorspecificextn.c that fixes coding style warning found by checkpatch.pl script. I am submitting this patch as required by Eudyptula Challenge.

That's a very long line for a changelog entry, please wrap them at the
proper lengths.

You need to describe _what_ warning you are fixing here, please be
specific.

Can you redo this patch please?

thanks,

greg k-h
