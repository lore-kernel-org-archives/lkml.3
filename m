Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245AbaEWCKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 22:10:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35125 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaEWCKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 22:10:17 -0400
Date: Fri, 23 May 2014 11:10:14 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] lib/devres.c: use dev in devm_request_and_ioremap
Message-ID: <20140523021014.GA26799@kroah.com>
References: <20140522193434.ee7b034dc707d249f0b30c2b@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140522193434.ee7b034dc707d249f0b30c2b@skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 07:34:34PM +0200, Fabian Frederick wrote:
> devm_request_and_ioremap was the only function to use device
> instead of dev(this fixes kernel-doc warning).
> 
> Also fix some checkpatch warnings.

Each patch should just do 1 thing.  Please break this up into a bug fix
patch and then a patch for the checkpatch warning(s).

thanks,

greg k-h
