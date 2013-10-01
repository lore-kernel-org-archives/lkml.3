Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab3JAWV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 18:21:28 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:44237 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab3JAWVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 18:21:25 -0400
Date: Tue, 1 Oct 2013 16:21:13 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Peter H?we <PeterHuewe@gmx.de>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>
Subject: Re: [PATCH 07/13] tpm: Remove tpm_show_caps_1_2
Message-ID: <20131001222113.GA22778@obsidianresearch.com>
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1379960083-8942-8-git-send-email-jgunthorpe@obsidianresearch.com>
 <201310020009.22952.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201310020009.22952.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 12:09:22AM +0200, Peter H?we wrote:

>    Since the tpm_spi_stm_st33, tpm_i2c_nuvoton and tpm_i2c_atmel drivers
>    are not yet merged and were heavily improved by you anyway, please
>    include this improvement directly in the new drivers.

Okay, it is easy enough to invert the patch order and put the drivers
last. I am not submitting the st33 driver, but when things are done I
will send Mathias a patch with the changes from this series that are
needed and he can deal with re-submitting his driver.

FWIW, I needed the drivers first to keep my world sane when testing
this thing, so the patches are all as-tested from my perspective.

Jason
