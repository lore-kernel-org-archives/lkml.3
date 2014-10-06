Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbaJFFPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 01:15:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43893 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbaJFFPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 01:15:39 -0400
Date: Mon, 6 Oct 2014 07:15:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 1/8] x86, microcode, intel: forbid some incorrect metadata
Message-ID: <20141006051536.GA4372@pd.tnic>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-2-git-send-email-hmh@hmh.eng.br>
 <20141005173453.GC9377@pd.tnic>
 <20141005193703.GB24081@khazad-dum.debian.net>
 <20141005211304.GA12003@pd.tnic>
 <20141005214907.GA28396@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141005214907.GA28396@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2014 at 06:49:08PM -0300, Henrique de Moraes Holschuh wrote:
> How about this:
> 
> 	/*
> 	 * 0 is not a valid microcode revision as it is used to detect the
> 	 * absence of any sucessful microcode update since reset /
> 	 * power-on, see MSR 0x8b (IA32_BIOS_SIGN_ID):
> 	 *
> 	 * "It is required that this register field be pre-loaded with zero
> 	 * prior to executing the CPUID, function 1. If the field remains
> 	 * equal to zero, then there is no microcode update loaded. Another
> 	 * non-zero value will be the signature."
> 	 */
> 

Yep.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
