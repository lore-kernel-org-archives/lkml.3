Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3J0Cax (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 22:30:53 -0400
Received: from void.printf.net ([89.145.121.20]:41893 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab3J0Caw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 22:30:52 -0400
From: Chris Ball <cjb@laptop.org>
To: Eric Ernst <eric.ernst@linux.intel.com>
Cc: adrian.hunter@intel.com, gregkh@linuxfoundation.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: Re: [PATCH] Add SDIO and MMC device ID support for CLV
References: <1382374481-197092-1-git-send-email-eric.ernst@linux.intel.com>
Date: Sat, 26 Oct 2013 22:30:46 -0400
In-Reply-To: <1382374481-197092-1-git-send-email-eric.ernst@linux.intel.com>
	(Eric Ernst's message of "Mon, 21 Oct 2013 09:54:41 -0700")
Message-ID: <8761sjla21.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Mon, Oct 21 2013, Eric Ernst wrote:
> This patch adds intel_mid clovertrail SDIO and eMMC device
> IDs to the sdhci-pci driver.
>
> Signed-off-by: Eric Ernst <eric.ernst@linux.intel.com>
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>

Thanks, pushed to mmc-next for 3.13.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
