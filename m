Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab3HNGh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 02:37:56 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:43347 "EHLO
	new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752401Ab3HNGhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 02:37:55 -0400
X-Greylist: delayed 663 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Aug 2013 02:37:55 EDT
X-Sasl-enc: mKngsDyFDJ1J610LwXkyieWs8+jIIoLSkypG81azgLSj 1376461610
Message-ID: <520B2327.9080404@iki.fi>
Date: Wed, 14 Aug 2013 09:26:47 +0300
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linn Crosetto <linn@hp.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        paulmck@linux.vnet.ibm.com, dhowells@redhat.com,
        mtk.manpages@gmail.com, yinghai@kernel.org, penberg@kernel.org,
        jacob.shin@amd.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] x86: avoid remapping data in parse_setup_data()
References: <1376348482-1357-1-git-send-email-linn@hp.com> <1376430401-67445-1-git-send-email-linn@hp.com>
In-Reply-To: <1376430401-67445-1-git-send-email-linn@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/14/13 12:46 AM, Linn Crosetto wrote:
> Type SETUP_PCI, added by setup_efi_pci(), may advertise a ROM size
> larger than early_memremap() is able to handle, which is currently
> limited to 256kB. If this occurs it leads to a NULL dereference in
> parse_setup_data().
>
> To avoid this, remap the setup_data header and allow parsing functions
> for individual types to handle their own data remapping.
>
> Signed-off-by: Linn Crosetto <linn@hp.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
