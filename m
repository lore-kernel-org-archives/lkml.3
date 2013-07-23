Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017Ab3GWUvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 16:51:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40097 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757933Ab3GWUvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 16:51:40 -0400
Date: Tue, 23 Jul 2013 13:51:39 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH 00/48] staging/lustre: minor cleanup and Intel Lustre sync
Message-ID: <20130723205139.GB10282@kroah.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 12:06:21AM +0800, Peng Tao wrote:
> Hi Greg,
> 
> The first two of the patchset are minor cleanup of lustre code. And the
> rest of it are patches ported from Intel Lustre tree. Please help to
> queue them.

I've applied most of these, see my comments on the ones I didn't.

Feel free to fix those up and resend.

Also please resync on my tree, as I tool some other lustre patches from
different developers that might conflict with your future changes.

thanks,

greg k-h
