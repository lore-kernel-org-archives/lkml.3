Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbaDNLzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:55:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019AbaDNLzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:55:14 -0400
Date: Mon, 14 Apr 2014 04:50:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] driver core: Clean up dev_get/set_drvdata
Message-ID: <20140414115051.GA20173@kroah.com>
References: <20140414124802.2859439e@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414124802.2859439e@endymion.delvare>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 12:48:02PM +0200, Jean Delvare wrote:
> This patch set is a proposal to revert most of commit b4028437. This
> would solve a memory leak and also allow to simplify and ultimately
> inline again functions dev_get_drvdata and dev_set_drvdata for smaller
> footprint and improved performance.
> 
> [PATCH 1/5] driver core: Move driver_data back to struct device
> [PATCH 2/5] driver core: dev_set_drvdata can no longer fail
> [PATCH 3/5] driver core: dev_set_drvdata returns void
> [PATCH 4/5] driver core: dev_get_drvdata: Don't check for NULL dev
> [PATCH 5/5] driver core: Inline dev_set/get_drvdata

Thanks, I'll queue this up later this week.

greg k-h
