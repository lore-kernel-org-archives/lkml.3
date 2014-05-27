Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbaE0R6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:58:19 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:41286 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbaE0R6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:58:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140526095730.GC25732@pd.tnic>
References: <1400169891-29546-1-git-send-email-tthayer@altera.com>
	<1400169891-29546-4-git-send-email-tthayer@altera.com>
	<20140526095730.GC25732@pd.tnic>
Date: Tue, 27 May 2014 12:58:15 -0500
Message-ID: <CAF03EBd+B5F_UOMOcn+pCE4dOL_24KZku4pweGym=Bip+H_-Rg@mail.gmail.com>
Subject: Re: [PATCHv5 3/3] edac: altera: Add EDAC support for Altera SoC SDRAM Controller
From: Thor Thayer <tthayer.linux@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Thor Thayer <tthayer@altera.com>, Rob Herring <robherring2@gmail.com>,
        pawel.moll@arm.com, Mark Rutland <mark.rutland@arm.com>,
        ijc+devicetree@hellion.org.uk, Kumar Gala <galak@codeaurora.org>,
        Rob Landley <rob@landley.net>, linux@arm.linux.org.uk,
        Dinh Nguyen <dinguyen@altera.com>, dougthompson@xmission.com,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-edac@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 4:57 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, May 15, 2014 at 11:04:51AM -0500, tthayer@altera.com wrote:
>> From: Thor Thayer <tthayer@altera.com>
>>
>> v2: Use the SDRAM controller registers to calculate memory size
>>     instead of the Device Tree. Update To & Cc list. Add maintainer
>>     information.
>>
>> v3: EDAC driver cleanup based on comments from Mailing list.
>>
>> v4: Panic on DBE. Add macro around inject-error reads to prevent
>>     them from being optimized out. Remove of_match_ptr since this
>>     will always use Device Tree.
>>
>> v5: Addition of printk to trigger function to ensure read vars
>>     are not optimized out.
>
> Yeah, you could turn those vX: messages into a real commit message -
> much better than none at all :-)
>
> Other than that, the edac bits look ok. I'll wait out until you guys've
> sorted the devicetree issues so ping me when it is ready to pick up.
>
> Thanks.
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --

Hi Boris,

Sorry about the commit message - I thought I'd fixed it. It will be
fixed in the next version.

I think Steffen and I have worked out how the devicetree should look.
I'll submit the changes soon.

Thanks,

Thor
