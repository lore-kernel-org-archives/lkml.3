Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab3JAXXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 19:23:42 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:54210 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784Ab3JAXXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 19:23:38 -0400
Date: Tue, 1 Oct 2013 17:23:27 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Peter H?we <PeterHuewe@gmx.de>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>
Subject: Re: [PATCH 08/13] tpm: Pull everything related to /dev/tpmX into
 tpm-dev.c
Message-ID: <20131001232327.GA5757@obsidianresearch.com>
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <201310020052.40497.PeterHuewe@gmx.de>
 <20131001225733.GA5286@obsidianresearch.com>
 <201310020114.18624.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201310020114.18624.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 01:14:18AM +0200, Peter H?we wrote:

> The makefile patch did fix it.

Great, feel free squash into the broken commit, or I can respin
things.

> (along with a small fix for the tpm_i2c_atmel driver ;)

Hum, I wonder why my compilers didn't whine, x86-64 should have
complained I think...

Anyhow, the %zd is the error here, expected_len should ideally be a
u32 as it comes from be32_to_cpu(hdr->length)

Regards,
Jason
