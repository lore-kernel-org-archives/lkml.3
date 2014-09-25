Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbaIYPQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:16:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32930 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaIYPQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:16:47 -0400
Date: Thu, 25 Sep 2014 17:15:51 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        sandeep_n@ti.com, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>, Kumar Gala <galak@codeaurora.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] firmware: add Keystone QMSS PDSP accumulator firmware
 blob
Message-ID: <20140925151551.GA18530@kroah.com>
References: <1411654423-29480-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411654423-29480-1-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 10:13:43AM -0400, Santosh Shilimkar wrote:
> From: Sandeep Nair <sandeep_n@ti.com>
> 
> QMSS(Queue Manager Sub System) uses PDSPs to implement various
> QM related functions like packet accumulation, QoS or event
> management.
> 
> Patch adds firmware blob for the QMSS accumulator
> functionality.
> 
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Sandeep Nair <sandeep_n@ti.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
> I know we are not adding firmware to kernel and the idea is to get them
> loaded via rootfs. But this firmware is for an infrastructure component
> which is needed for Keystone.

What does "infrastructure component" mean?

What is "Keystone"?

> The respective drivers got into the queue
> and the firmware was dropped from the series to follow the firmware tree.

Did you submit this to the linux-firmware tree?

Did the driver that needs this get merged into Linus's tree yet?

thanks,

greg k-h
