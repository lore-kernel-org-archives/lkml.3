Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbaAXVeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 16:34:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44994 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbaAXVe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 16:34:29 -0500
Date: Fri, 24 Jan 2014 13:35:20 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jason Baron <jbaron@akamai.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] dynamic_debug: replace obselete simple_strtoul()
 with kstrtouint()
Message-ID: <20140124213520.GA11310@kroah.com>
References: <1390483232-7160-1-git-send-email-a.ryabinin@samsung.com>
 <1390483232-7160-3-git-send-email-a.ryabinin@samsung.com>
 <52E2C71A.7040002@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E2C71A.7040002@akamai.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 03:03:38PM -0500, Jason Baron wrote:
> Hi,
> 
> I think we want some sort of commit message for this patch. But they
> all look good to me and they tested fine.
> 
> Acked-by: Jason Baron <jbaron@akamai.com>
> 
> Greg, Can you pick up this series?

Will do, after 3.14-rc1 is out, thanks.

greg k-h
