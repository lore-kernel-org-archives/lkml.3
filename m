Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab3GXSFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:05:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab3GXSFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:05:17 -0400
Date: Wed, 24 Jul 2013 11:05:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>,
        Peng Tao <tao.peng@emc.com>
Subject: Re: [PATCH-RESEND 2/3] staging/lustre: fix build on non-x86
Message-ID: <20130724180516.GA4958@kroah.com>
References: <1374688821-9874-1-git-send-email-bergwolf@gmail.com>
 <1374688821-9874-3-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374688821-9874-3-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 02:00:20AM +0800, Peng Tao wrote:
> On non-x86 we will build with Lustre's errno translate code but
> it has a few issues.
> 
> Cc: Andreas Dilger <andreas.dilger@intel.com>
> Signed-off-by: Peng Tao <tao.peng@emc.com>

You forgot your "From: Peng Tao <tao.peng@emc.com>" line in this, and
the third, patch to get the authorship correct.

thanks,

greg k-h
