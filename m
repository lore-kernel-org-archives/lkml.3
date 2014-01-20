Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbaATRkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 12:40:15 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:17406 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750823AbaATRkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 12:40:13 -0500
Date: Mon, 20 Jan 2014 17:39:41 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] ARM: add support for AT_HWCAP2 ELF auxv entry
Message-ID: <20140120173941.GE29971@arm.com>
References: <1387807592-26375-1-git-send-email-ard.biesheuvel@linaro.org>
 <1387807592-26375-2-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387807592-26375-2-git-send-email-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 02:06:28PM +0000, Ard Biesheuvel wrote:
> This enables AT_HWCAP2 for ARM. The generic support for this
> new ELF auxv entry was added in commit 2171364d1a9 (powerpc:
> Add HWCAP2 aux entry)
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
