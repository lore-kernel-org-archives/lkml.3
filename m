Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab3GBWcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 18:32:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55151 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab3GBWcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 18:32:13 -0400
Message-ID: <51D354CA.7010305@infradead.org>
Date: Tue, 02 Jul 2013 15:31:38 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Add support driver for Intel Rapid Start Technology
References: <1372804061-2260-1-git-send-email-mjg59@srcf.ucam.org>
In-Reply-To: <1372804061-2260-1-git-send-email-mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/13 15:27, Matthew Garrett wrote:
> Intel Rapid Start Technology is a firmware-based suspend-to-disk
> implementation. Once placed in S3, the device will wake once either a
> timeout elapses or the battery reaches a critical level. It will then resume
> to the firmware and copy the contents of RAM to a specialised partition, and
> then power off the machine. If the user turns the machine back on the
> firmware will copy the contents of the partition back to RAM and then resume
> from S3 as normal.
> 
> This driver provides an interface for configuring the wakeup events and
> timeout. It still requires firmware support and an appropriate suspend
> partition.
> 
> Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
> ---
>  .../ABI/testing/sysfs-driver-intel-rapid-start     |  21 +++
>  drivers/platform/x86/intel-rst.c                   | 209 +++++++++++++++++++++
>  2 files changed, 230 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-driver-intel-rapid-start
>  create mode 100644 drivers/platform/x86/intel-rst.c

Kconfig and Makefile changes?

Is RST described in the current ACPI spec or somewhere else?

thanks,

-- 
~Randy
