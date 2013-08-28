Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab3H1FEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 01:04:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab3H1FEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 01:04:49 -0400
Date: Tue, 27 Aug 2013 22:07:08 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alex Elder <alex.elder@linaro.org>
Cc: linux-kernel@vger.kernel.org, Yehuda Sadeh <yehuda@inktank.com>,
        Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH 02/15] rbd: convert bus code to use bus_groups
Message-ID: <20130828050708.GA15491@kroah.com>
References: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
 <1377293081-10957-2-git-send-email-gregkh@linuxfoundation.org>
 <521C9D14.7090502@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521C9D14.7090502@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 07:35:32AM -0500, Alex Elder wrote:
> On 08/23/2013 04:24 PM, Greg Kroah-Hartman wrote:
> > The bus_attrs field of struct bus_type is going away soon, dev_groups
> > should be used instead.  This converts the RBD bus code to use the
> > correct field.
> > 
> > Cc: Yehuda Sadeh <yehuda@inktank.com>
> > Cc: Sage Weil <sage@inktank.com>
> > Cc: Alex Elder <elder@inktank.com>
> 
> Looks reasonable to me.
> 
> Acked-by: Alex Elder <elder@linaro.org>

Thanks for the review.

greg k-h
