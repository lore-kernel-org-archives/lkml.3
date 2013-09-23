Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab3IWV1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:27:15 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34997 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338Ab3IWV1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:27:13 -0400
Message-ID: <5240B22B.5060406@linux.vnet.ibm.com>
Date: Mon, 23 Sep 2013 16:27:07 -0500
From: Joel Schopp <jschopp@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        tpmdd-devel@lists.sourceforge.net
CC: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        Sirrix AG <tpmdd@sirrix.com>
Subject: Re: [tpmdd-devel] [PATCH 00/13] TPM cleanup
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
In-Reply-To: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092321-7182-0000-0000-0000087FC4CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Jason Gunthorpe (13):
>   tpm: ibmvtpm: Use %zd formatting for size_t format arguments
>   tpm atmel: Call request_region with the correct base
>   tpm: xen-tpmfront: Fix default durations
>   tpm: Store devname in the tpm_chip
>   tpm: Use container_of to locate the tpm_chip in tpm_open
>   tpm: Remove redundant dev_set_drvdata
>   tpm: Remove tpm_show_caps_1_2
>   tpm: Pull everything related to /dev/tpmX into tpm-dev.c
>   tpm: Pull everything related to sysfs into tpm-sysfs.c
>   tpm: Create a tpm_class_ops structure and use it in the drivers
>   tpm: Use the ops structure instead of a copy in tpm_vendor_specific
>   tpm: st33: Remove chip->data_buffer access from this driver
>   tpm: Make tpm-dev allocate a per-file structure
> 
>  drivers/char/tpm/Makefile           |   2 +-
>  drivers/char/tpm/tpm-dev.c          | 213 +++++++++++++++
>  drivers/char/tpm/tpm-sysfs.c        | 318 ++++++++++++++++++++++
>  drivers/char/tpm/tpm.c              | 524 +++---------------------------------
>  drivers/char/tpm/tpm.h              |  86 +++---
>  drivers/char/tpm/tpm_atmel.c        |  30 +--
>  drivers/char/tpm/tpm_i2c_atmel.c    |  42 +--
>  drivers/char/tpm/tpm_i2c_infineon.c |  44 +--
>  drivers/char/tpm/tpm_i2c_nuvoton.c  |  42 +--
>  drivers/char/tpm/tpm_i2c_stm_st33.c |  51 +---
>  drivers/char/tpm/tpm_ibmvtpm.c      |  44 +--
>  drivers/char/tpm/tpm_infineon.c     |  28 +-
>  drivers/char/tpm/tpm_nsc.c          |  28 +-
>  drivers/char/tpm/tpm_spi_stm_st33.c |  50 +---
>  drivers/char/tpm/tpm_tis.c          |  43 +--
>  drivers/char/tpm/xen-tpmfront.c     |  57 +---
>  include/linux/tpm.h                 |  15 ++
>  17 files changed, 638 insertions(+), 979 deletions(-)
>  create mode 100644 drivers/char/tpm/tpm-dev.c
>  create mode 100644 drivers/char/tpm/tpm-sysfs.c
> 

For what it's worth I have nothing to say except the cleanups look sane
to me.
Reviewed-by: Joel Schopp <jschopp@linux.vnet.ibm.com>

