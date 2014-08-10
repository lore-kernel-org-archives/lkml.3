Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaHJMNA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 08:13:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbaHJML2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 08:11:28 -0400
Date: Sat, 9 Aug 2014 21:29:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Martin Kepplinger <martink@posteo.de>
Cc: oleg.drokin@intel.com, devel@driverdev.osuosl.org,
        andreas.dilger@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: use NULL instead of 0 for non-integers
Message-ID: <20140810042922.GA25313@kroah.com>
References: <1407098737-27911-1-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407098737-27911-1-git-send-email-martink@posteo.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2014 at 10:45:36PM +0200, Martin Kepplinger wrote:
> This fixes sparse errors where 0 is used for non-integers.
> 
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> ---
> applies to -next20140802

Someone else already did this same change, sorry :(

greg k-h
