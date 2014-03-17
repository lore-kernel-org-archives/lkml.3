Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750883AbaCQS6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 14:58:04 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:64088 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaCQS6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 14:58:00 -0400
Date: Mon, 17 Mar 2014 14:57:55 -0400
From: Tejun Heo <tj@kernel.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@deeprootsystems.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        spear-devel@list.st.com
Subject: Re: [PATCH 0/4] ata: add remaining new-style AHCI platform drivers
Message-ID: <20140317185755.GA17373@mtj.dyndns.org>
References: <1395081118-15248-1-git-send-email-b.zolnierkie@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395081118-15248-1-git-send-email-b.zolnierkie@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 07:31:54PM +0100, Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> This patch series adds new-style AHCI platform drivers for DaVinci DA850
> AHCI controller and ST SPEAr1340 AHCI controller.  As a preparation for
> adding these drivers it also fixes ahci_platform_data->suspend() handling
> (patch #1) and moves library AHCI platform code to its own file (patch #2).
> The new AHCI platform drivers are only compile tested (they are marked as
> experimental because of this) and I would ask somebody with the hardware
> to verify them (thanks!).

Nice cleanups.  I'll apply the patches once the drivers are verified
to work.

Thanks!

-- 
tejun
