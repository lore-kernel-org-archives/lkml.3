Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbaLNODq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 09:03:46 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35090 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbaLNODm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 09:03:42 -0500
Message-ID: <548D98B8.3010003@linux.vnet.ibm.com>
Date: Sun, 14 Dec 2014 09:03:36 -0500
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>
CC: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org,
        trousers-tech@lists.sourceforge.net
Subject: Re: [PATCH v10 1/8] tpm: merge duplicate transmit_cmd() functions
References: <1418413600-5400-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1418413600-5400-2-git-send-email-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <1418413600-5400-2-git-send-email-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121414-0029-0000-0000-0000016AC468
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2014 02:46 PM, Jarkko Sakkinen wrote:
> Merged transmit_cmd() functions in tpm-interface.c and tpm-sysfs.c.
> Added "tpm_" prefix for consistency sake. Changed cmd parameter as
> opaque. This enables to use separate command structures for TPM1
> and TPM2 commands in future. Loose coupling works fine here.
>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Reviewed-by: Jasob Gunthorpe <jason.gunthorpe@obsidianresearch.com>
> Reviewed-by: Stephan Berger <stephan.berger@linux.vnet.ibm.com>

Not quite ... Stefan Berger <stefanb@linux.vnet.ibm.com>

     Stefan

