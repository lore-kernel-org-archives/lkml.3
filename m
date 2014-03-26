Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbaCZOfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 10:35:14 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:46508 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaCZOfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 10:35:12 -0400
Date: Wed, 26 Mar 2014 10:35:08 -0400
From: Tejun Heo <tj@kernel.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-ide@vger.kernel.org,
        spear-devel@list.st.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: fix ARASAN CompactFlash PATA driver dependencies
Message-ID: <20140326143508.GE7171@htj.dyndns.org>
References: <1565826.7Ejj6LS6x7@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565826.7Ejj6LS6x7@amdc1032>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 03:33:37PM +0100, Bartlomiej Zolnierkiewicz wrote:
> Make pata_arasan_cf host driver depend on ARCH_SPEAR13XX config
> option as ARASAN CompactFlash PATA support is specific to ST
> SPEAr13xx SoCs and the driver to work requires suitable device
> tree node (or platform device) to be defined.  Additionally
> allow the driver build if COMPILE_TEST config option is set.
> 
> Cc: Viresh Kumar <viresh.linux@gmail.com>
> Cc: Shiraz Hashim <shiraz.hashim@st.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Applied to libata/for-3.15.  Thanks.

-- 
tejun
