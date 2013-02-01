Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab3BAQQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 11:16:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:50988 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234Ab3BAQQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 11:16:36 -0500
Date: Fri, 1 Feb 2013 17:18:36 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@android.com, arve@android.com,
        john.stultz@linaro.org, Dave.Butcher@arm.com
Subject: Re: [PATCH 1/2] staging: android: ashmem: fix ashmem pin/unpin
 interface
Message-ID: <20130201161836.GA29021@kroah.com>
References: <1359734881-15093-1-git-send-email-serban.constantinescu@arm.com>
 <1359734881-15093-2-git-send-email-serban.constantinescu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359734881-15093-2-git-send-email-serban.constantinescu@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 04:08:00PM +0000, Serban Constantinescu wrote:
> The values exchanged between kernel and userspace through struct
> ashmem_pin should be of type size_t. This change won't affect the
> existing interface but will stand as the basis of 64bit compat layer.

How do you define size_t with a 64bit kernel and a 32bit userspace
properly?  Doesn't this change open up a bunch of problems?

thanks,

greg k-h
