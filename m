Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab3IAXQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 19:16:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49071 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab3IAXQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 19:16:27 -0400
Message-ID: <5223CA9C.5020505@zytor.com>
Date: Sun, 01 Sep 2013 16:15:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linn Crosetto <linn@hp.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        paulmck@linux.vnet.ibm.com, dhowells@redhat.com,
        mtk.manpages@gmail.com, yinghai@kernel.org, penberg@kernel.org,
        jacob.shin@amd.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] x86: avoid remapping data in parse_setup_data()
References: <1376348482-1357-1-git-send-email-linn@hp.com> <1376430401-67445-1-git-send-email-linn@hp.com>
In-Reply-To: <1376430401-67445-1-git-send-email-linn@hp.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 02:46 PM, Linn Crosetto wrote:
> Type SETUP_PCI, added by setup_efi_pci(), may advertise a ROM size
> larger than early_memremap() is able to handle, which is currently
> limited to 256kB. If this occurs it leads to a NULL dereference in
> parse_setup_data().
> 
> To avoid this, remap the setup_data header and allow parsing functions
> for individual types to handle their own data remapping.
> 
> Signed-off-by: Linn Crosetto <linn@hp.com>

So it seems this patch generates some new sparse warnings.  Can you
please create an incremental fixup patch to address those sparse
warnings?  (See email from Fengguang Wu's robot.)

	-hpa


