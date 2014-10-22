Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbaJVQe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:34:29 -0400
Received: from mout.gmx.net ([212.227.15.15]:57184 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbaJVQe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:34:27 -0400
MIME-Version: 1.0
Message-ID: <trinity-cda2c5de-5cfe-4522-ac24-466d34965655-1413995642086@3capp-gmx-bs09>
From: "Peter Huewe" <PeterHuewe@gmx.de>
To: "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>
Cc: "Ashley Lai" <ashley@ashleylai.com>,
        "Marcel Selhorst" <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, josh.triplett@intel.com,
        christophe.ricard@gmail.com, jason.gunthorpe@obsidianresearch.com,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>
Subject: Aw: [PATCH v1 0/3] tpm: prepare for TPM2
Content-Type: text/plain; charset=UTF-8
Date: Wed, 22 Oct 2014 18:34:02 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <1413995036-22497-1-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1413995036-22497-1-git-send-email-jarkko.sakkinen@linux.intel.com>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K0:KO7ivp+5mrt2cqS/kDhMll9ArAvuMWmZqpCpvyPInHv
 v3keHcQBVfXa9sUsLRBxxan0BfIjlgxmy6wvK9558GP5pk+o90
 512jO6GcJTGqUlo9I9x/DvT/QXI8kFYmK6TVo1egaDP2b2/z4J
 gqrgnA8//yBQnR+SL9Tp1LZbHv8OT/CvvdRFsqgeuT6G0//jMZ
 IYWDrsn0B7znGRzUT2+xo9DOo9bxZSF98+jh2OOd4o7ZXWpSZw
 35RKSGpL4kpXgG0wx7RCW5beZJMWz56T1cvsuWJfwX8bocdpBi GfjH3E=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jarkko,

> Jarkko Sakkinen (3):
> tpm: merge duplicate transmit_cmd() functions
> tpm: two-phase chip management functions
> tpm: fix multiple race conditions in tpm_ppi.c

the patchset introduces a sparse error:
  CHECK   /home/phuewe/linux-2.6-host/drivers/char/tpm/tpm_tis.c
/home/phuewe/linux-2.6-host/drivers/char/tpm/tpm_tis.c:783:39: warning: Using plain integer as NULL pointer
/home/phuewe/linux-2.6-host/drivers/char/tpm/tpm_tis.c:868:39: warning: Using plain integer as NULL pointer

apart from that I'll review it this evening.

Thanks,
Peter
