Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbaKFXdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:33:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaKFXdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 18:33:12 -0500
Date: Thu, 6 Nov 2014 15:33:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jaime Arrocha <jarrocha27@gmail.com>
Cc: liodot@gmail.com, charrer@alacritech.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: slicoss.c: checkpatch warnings
Message-ID: <20141106233311.GA31846@kroah.com>
References: <20141106232454.GA16568@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106232454.GA16568@localhost.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 05:24:54PM -0600, Jaime Arrocha wrote:
> Correction of warnings of lines with 80 plus character.
> Some warnings were left in favor of readability, others
> were created by breaking quoted strings.
> Memory barriers comments are obvious but remove warnings.
> Let me know if any corrections are needed.
> 
> Signed-off-by: Jaime Arrocha <jarrocha27@gmail.com>

Please only make one change per patch, so this needs to be split up into
multiple patches.

Also use scripts/get_maintainer.pl to find the correct mailing lists to
cc on the patch.

thanks,

greg k-h
