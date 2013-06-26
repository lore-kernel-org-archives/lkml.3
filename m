Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab3FZOgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:36:17 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:45037 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab3FZOgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:36:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130626141528.GF20274@pd.tnic>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
 <1372183863-11333-4-git-send-email-leif.lindholm@linaro.org>
 <CACxGe6sH4dAVryBp7TeUmrwsJmnMdLsQm++U4EVDJVNi9pnqYw@mail.gmail.com>
 <20130626135417.GP22026@console-pimps.org> <20130626141528.GF20274@pd.tnic>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 26 Jun 2013 15:35:53 +0100
X-Google-Sender-Auth: 84gGdsypaUDpfwCECbd_09x0Dy4
Message-ID: <CACxGe6u43xOF2oVAF2yaO=ykLrQpgPPQTshjwxFdrA24VFYMcQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] arm: Add [U]EFI runtime services support
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, matt.fleming@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 3:15 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Wed, Jun 26, 2013 at 02:54:17PM +0100, Matt Fleming wrote:
>> On Wed, 26 Jun, at 02:46:09PM, Grant Likely wrote:
>> > Eventually we'll need to look at how this interacts with kexec. A
>> > kexec'd kernel will need to use the mapping already chosen by a
>> > previous kernel, but that's an issue for another patch series.
>>
>> FYI, this is exactly what Borislav has been tackling on x86 recently. It
>> would be nice if we could find one scheme that suits everyone.
>
> Is this arm 32 or 64-bit? Because we haven't talked about 32-bit on x86
> either. From skimming over the code, I'm not sure the same top-down
> allocation and 1:1 mapping would work there. But I haven't looked hard
> yet so I dunno.

This is arm 32. We'll be looking at arm 64 next.

g.
