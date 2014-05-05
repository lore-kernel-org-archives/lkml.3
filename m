Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbaEEDEe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 23:04:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbaEEDEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 23:04:33 -0400
Date: Sun, 4 May 2014 20:04:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH] drivercore: fix a corner case for deferred probe
Message-ID: <20140505030432.GA11957@kroah.com>
References: <1398045202-5714-1-git-send-email-weiyang@linux.vnet.ibm.com>
 <20140505022805.GA15162@richard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505022805.GA15162@richard>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 10:28:05AM +0800, Wei Yang wrote:
> Hi, all
> 
> Anyone has some comment on this?

Did you miss the patch from Grant that is now in Linus's tree that
should resolve this issue?

thanks,

greg k-h
