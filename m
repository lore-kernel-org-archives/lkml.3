Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759120AbaDJTQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 15:16:55 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:47708 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161205AbaDJTPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 15:15:30 -0400
Date: Thu, 10 Apr 2014 12:15:23 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: wim@iguana.be, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/2] x86: intel-mid: add watchdog platform code for
 Merrifield
Message-ID: <20140410191523.GA6206@roeck-us.net>
References: <1396990744-10695-1-git-send-email-david.a.cohen@linux.intel.com>
 <1396990744-10695-3-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396990744-10695-3-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 01:59:04PM -0700, David Cohen wrote:
> This patch adds platform code for Intel Merrifield.
> Since the watchdog is not part of SFI table, we have no other option but
> to manually register watchdog's platform device (argh!).
> 
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---

Does it really make sense to have this as separate patch ? 

It is quite common for watchdog (and many other) drivers to
register the driver and instantiate the device. I think it
would be better and more consistent to have both patches
merged into one.

Thanks,
Guenter
