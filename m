Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbaCYTRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 15:17:51 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63723 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbaCYTRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 15:17:49 -0400
Date: Tue, 25 Mar 2014 15:17:45 -0400
From: Tejun Heo <tj@kernel.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        spear-devel@list.st.com
Subject: Re: [PATCH v4 0/4] ata: ahci_platform related cleanups
Message-ID: <20140325191745.GB3279@htj.dyndns.org>
References: <1395773501-6663-1-git-send-email-b.zolnierkie@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395773501-6663-1-git-send-email-b.zolnierkie@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 07:51:37PM +0100, Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> This patch series:
> - fixes ahci_platform_data->suspend() handling
> - moves library AHCI platform code to its own file
> - adds a new-style AHCI platform driver for DaVinci DA850 AHCI controller
> - updates DaVinci DA850 platform code
> 
> Changes since v3:
> - updated for ahci_xgene

Aplied 1-4 to libata/for-3.15.

Thanks!

-- 
tejun
