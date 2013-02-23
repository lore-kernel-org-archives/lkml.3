Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956Ab3BWOkM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 09:40:12 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:53104 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758190Ab3BWOkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 09:40:07 -0500
Date: Sat, 23 Feb 2013 06:40:47 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Takahisa Tanaka <mc74hc00@gmail.com>
Cc: linux-watchdog@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        Arkadiusz Miskiewicz <arekm@maven.pl>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-kernel@vger.kernel.org,
        Florian Mickler <florian@mickler.org>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Joseph Salisbury <josephtsalisbury@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] sp5100_tco: Remove code that may cause a boot failure
Message-ID: <20130223144047.GA29325@kroah.com>
References: <1361619112-7481-1-git-send-email-mc74hc00@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361619112-7481-1-git-send-email-mc74hc00@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2013 at 08:31:52PM +0900, Takahisa Tanaka wrote:
> The critical problem which can't boot OS until the power is completely
> cut off found on PC with SB700 chipset. This patch fix the problem, but,
> this patch prevents the sp5100_tco driver from using watchdog timer
> function of chipset on PC with SP5100 or SB7x0 chipset.
> 
> Re-programming the MMIO address registers for the watchdog timer must
> have generated the problem. However, I don't know root cause so far.
> So, I decided to remove the concerned codes.
> 
> Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1116835
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43176
> 
> Signed-off-by: Takahisa Tanaka <mc74hc00@gmail.com>
> ---
>  drivers/watchdog/sp5100_tco.c | 140 ++++--------------------------------------
>  drivers/watchdog/sp5100_tco.h |   2 +-
>  2 files changed, 14 insertions(+), 128 deletions(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
