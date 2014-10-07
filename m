Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbaJGOrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:47:09 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:57601 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbaJGOrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:47:07 -0400
Date: Tue, 7 Oct 2014 15:47:03 +0100
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: Re: [PATCH] efi: Capsule update support
Message-ID: <20141007144703.GL14343@console-pimps.org>
References: <1412692886-25306-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412692886-25306-1-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Oct, at 03:41:26PM, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> The EFI capsule mechanism allows data blobs to be passed to the EFI
> firmware. This patch just introduces the main infrastruture for
> interacting with the firmware.
> 
> Once a capsule has been passed to the firmware, the next reboot will
> always be performed using the ResetSystem() EFI runtime service, which
> may involve overriding the reboot type specified by reboot=. This
> ensures the reset value returned by QueryCapsuleCapabilities() is used
> to reset the system, which is required for the capsule to be processed.
> 
> Cc: Leif Lindholm <leif.lindholm@linaro.org>
> Cc: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>

Bah, sorry. Ignore this one, it was supposed to be part of a series.
I'll resend.

-- 
Matt Fleming, Intel Open Source Technology Center
