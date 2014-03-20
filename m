Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbaCTJOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:14:38 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:52489 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752245AbaCTJOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:14:34 -0400
X-Greylist: delayed 1101 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Mar 2014 05:14:28 EDT
Date: Thu, 20 Mar 2014 14:27:17 +0530
From: Pratyush Anand <pratyush.anand@st.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Tejun Heo <tj@kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@gmail.com>,
        Mohit Kumar <mohit.kumar@st.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH 4/4] ata: add new-style AHCI platform driver for ST
 SPEAr1340 AHCI controller
Message-ID: <20140320085717.GC4607@pratyush-vbox>
References: <1395081118-15248-1-git-send-email-b.zolnierkie@samsung.com>
 <1395081118-15248-5-git-send-email-b.zolnierkie@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1395081118-15248-5-git-send-email-b.zolnierkie@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-20_02:2014-03-19,2014-03-20,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 02:31:58AM +0800, Bartlomiej Zolnierkiewicz wrote:
> The new driver is named ahci_spear1340 and is only compile tested.  Once
> it is tested on the real hardware and verified to work correctly, the legacy
> platform code (which depends on the deprecated struct ahci_platform_data)
> can be removed.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

This patch will not be needed any more, since SPEAr sata platform code has
already been cleaned up.

See:
https://lkml.org/lkml/2014/2/28/174

Regards
Pratyush
