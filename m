Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbaIHWYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:24:55 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:64924 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218AbaIHWYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:24:52 -0400
Date: Tue, 9 Sep 2014 07:24:47 +0900
From: Tejun Heo <tj@kernel.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: linux-ide@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        b.zolnierkie@samsung.com
Subject: Re: [PATCH v4 2/3] ata: Add Qualcomm ARM SoC AHCI SATA host
 controller driver
Message-ID: <20140908222447.GC3806@mtj.dyndns.org>
References: <1410194390-29007-1-git-send-email-galak@codeaurora.org>
 <1410194390-29007-2-git-send-email-galak@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410194390-29007-2-git-send-email-galak@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 11:39:49AM -0500, Kumar Gala wrote:
> Add support for the Qualcomm AHCI SATA controller that exists on several
> SoC and specifically the IPQ806x family of chips.  The IPQ806x SATA support
> requires the associated IPQ806x SATA PHY Driver to be enabled as well.
> 
> Signed-off-by: Kumar Gala <galak@codeaurora.org>

Please cc Hans de Goede <hdegoede@redhat.com> on all ahci_platform
related changes.

Thanks.

-- 
tejun
