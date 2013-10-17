Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab3JQO5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:57:38 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:54242 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756184Ab3JQO5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:57:36 -0400
Date: Thu, 17 Oct 2013 08:57:24 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Ashley Lai <ashley@ashleylai.com>
Cc: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        tpmdd-devel@lists.sourceforge.net, Peter H?we <PeterHuewe@gmx.de>,
        Sirrix AG <tpmdd@sirrix.com>
Subject: Re: [tpmdd-devel] TPM patches for 2.13
Message-ID: <20131017145724.GA6528@obsidianresearch.com>
References: <20131006193120.GA26137@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131006193120.GA26137@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 01:31:20PM -0600, Jason Gunthorpe wrote:
> I've prepared this branch:
> 
> https://github.com/jgunthorpe/linux/commits/for-tpm
> dd783708a8c6fd713c784be68fcbcb7000c43c49
> 
> Jason Gunthorpe (11):
>       tpm: ibmvtpm: Use %zd formatting for size_t format arguments
>       tpm atmel: Call request_region with the correct base
>       tpm: Store devname in the tpm_chip
>       tpm: Use container_of to locate the tpm_chip in tpm_open
>       tpm: Remove redundant dev_set_drvdata
>       tpm: st33: Remove chip->data_buffer access from this driver
>       tpm: Remove tpm_show_caps_1_2
>       tpm: Rename tpm.c to tpm-interface.c
>       tpm: Merge the tpm-bios module with tpm.o
>       tpm: Add support for the Nuvoton NPCT501 I2C TPM
>       tpm: Add support for Atmel I2C TPMs
> 
> Which contains the first half of the clean-up patches and my two
> drivers. The cleanups are well ack'd now, and I've done quite a bit of
> testing with the two drivers, so I'd like to see agreement that this
> batch can move forward as a series, and the other patches can sit
> ontop of this series.

Folks, the 3.13 merge window is fast approaching, any chance of
advancing this work?

Jason
