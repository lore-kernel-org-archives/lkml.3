Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbaAHUZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:25:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42001 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaAHUZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:25:43 -0500
Date: Wed, 8 Jan 2014 12:26:13 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: x86@kernel.org, linuxppc-dev@lists.ozlabs.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ashok Raj <ashok.raj@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH RFC 1/3] drivers: base: support cpu cache information
 interface to userspace via sysfs
Message-ID: <20140108202613.GD8417@kroah.com>
References: <1389209168-17189-1-git-send-email-sudeep.holla@arm.com>
 <1389209168-17189-2-git-send-email-sudeep.holla@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389209168-17189-2-git-send-email-sudeep.holla@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 07:26:06PM +0000, Sudeep Holla wrote:
> From: Sudeep Holla <sudeep.holla@arm.com>
> 
> This patch adds initial support for providing processor cache information
> to userspace through sysfs interface. This is based on x86 implementation
> and hence the interface is intended to be fully compatible.
> 
> A per-cpu array of cache information maintained is used mainly for
> sysfs-related book keeping.
> 
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> ---
>  drivers/base/Makefile     |   2 +-
>  drivers/base/cacheinfo.c  | 296 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/cacheinfo.h |  43 +++++++
>  3 files changed, 340 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/base/cacheinfo.c
>  create mode 100644 include/linux/cacheinfo.h

You are creating sysfs files, yet you didn't add Documentation/ABI/
information, which is required.  Please fix that.

greg k-h
