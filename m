Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab3GXRgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:36:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52699 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab3GXRgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:36:02 -0400
Date: Wed, 24 Jul 2013 10:36:01 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH-RESEND 0/8] staging/lustre: Intel tree sync and two fixups
Message-ID: <20130724173601.GA24935@kroah.com>
References: <1374686251-3152-1-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374686251-3152-1-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 01:17:23AM +0800, Peng Tao wrote:
> Hi Greg,
> 
> I've fixed up the rest of Intel tree ported patches and rebased them on top
> of your staging-next. Also I found that the Lustre errno translate code breaks
> build on non-x86 systems. I've added one patch to fix it. Please queue them if
> they are OK to you.

I've applied some of these, please refresh your tree, reorder the
bugfix, and resend the ones I didn't apply.

Thanks for fixing up the email address stuff.

greg k-h
