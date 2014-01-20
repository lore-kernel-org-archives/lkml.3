Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaATRkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 12:40:43 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:17662 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751285AbaATRkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 12:40:40 -0500
Date: Mon, 20 Jan 2014 17:40:08 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] binfmt_elf: add ELF_HWCAP2 to compat auxv
 entries
Message-ID: <20140120174008.GF29971@arm.com>
References: <1387807592-26375-1-git-send-email-ard.biesheuvel@linaro.org>
 <1387807592-26375-3-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387807592-26375-3-git-send-email-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 02:06:29PM +0000, Ard Biesheuvel wrote:
> Add ELF_HWCAP2 to the set of auxv entries that is passed to
> a 32-bit ELF program running in 32-bit compat mode under a
> 64-bit kernel.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
