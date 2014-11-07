Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaKGTWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 14:22:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42917 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbaKGTWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 14:22:14 -0500
Date: Fri, 7 Nov 2014 11:22:13 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH v5 03/11] drivers: base: add cpu_device_create to support
 per-cpu devices
Message-ID: <20141107192213.GA30923@kroah.com>
References: <1412084912-2767-1-git-send-email-sudeep.holla@arm.com>
 <1412084912-2767-4-git-send-email-sudeep.holla@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412084912-2767-4-git-send-email-sudeep.holla@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 02:48:24PM +0100, Sudeep Holla wrote:
> This patch adds a new function to create per-cpu devices.
> This helps in:
> 1. reusing the device infrastructure to create any cpu related
>    attributes and corresponding sysfs instead of creating and
>    dealing with raw kobjects directly
> 2. retaining the legacy path(/sys/devices/system/cpu/..) to support
>    existing sysfs ABI
> 3. avoiding to create links in the bus directory pointing to the
>    device as there would be per-cpu instance of these devices with
>    the same name since dev->bus is not populated to cpu_sysbus on
>    purpose
> 
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Tested-by: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: David Herrmann <dh.herrmann@gmail.com>
> Cc: Kay Sievers <kay@vrfy.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
