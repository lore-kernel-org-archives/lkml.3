Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab3JANyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 09:54:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52044 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab3JANyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 09:54:13 -0400
Date: Tue, 1 Oct 2013 06:54:19 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the driver-core tree
Message-ID: <20131001135419.GC19805@kroah.com>
References: <20131001110344.GA20249@ulmo.nvidia.com>
 <1380625644-11331-4-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380625644-11331-4-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 01:07:20PM +0200, Thierry Reding wrote:
> Today's linux-next merge of the driver-core tree got conflicts in
> 
> 	include/linux/netdevice.h
> 
> I fixed it up (see below). Please check if the resolution looks correct.

Looks correct to me, thanks.

greg k-h
