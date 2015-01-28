Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbbA1UPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:15:12 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:39108 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbbA1UPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:15:08 -0500
Message-ID: <54C9434A.30000@linaro.org>
Date: Wed, 28 Jan 2015 14:15:06 -0600
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC: Behan Webster <behanw@converseincode.com>, bcm@fixthebug.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Matt Porter <mporter@linaro.org>,
        bcm-kernel-feedback-list@broadcom.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] bcm: address clang inline asm incompatibility
References: <1422422306-27473-1-git-send-email-behanw@converseincode.com>	<CAKv+Gu_NCgMmX_LQqi7vtjtP4ofrW+kx8FPgRd4-LWwK=73-xg@mail.gmail.com>	<54C8EE04.6060809@linaro.org>	<CAKv+Gu8CrMqwqBOF8rYa3RP1=gfCthwP=1k9kQ73v6+Sxwah4A@mail.gmail.com>	<54C91791.9030508@linaro.org>	<CAKv+Gu8P8eC+bmerCpbSX=USODqE=U7WnLeiCfhHJ8SSVAzPDw@mail.gmail.com>	<CAKv+Gu9fc_F1iC5NAwaG_ed3RRhYnxEBLbuLgW0Oa_qJ96j-gA@mail.gmail.com>	<54C9383D.10901@linaro.org>	<CAKv+Gu88G2QqAupD9j4_-t2=0VJGNbWkUViLBM2nUuyuN-PHWA@mail.gmail.com> <CAKv+Gu8B7G3tNahkguDBjCOQih4_ywRtwaJz2D2b+vY1249-DA@mail.gmail.com>
In-Reply-To: <CAKv+Gu8B7G3tNahkguDBjCOQih4_ywRtwaJz2D2b+vY1249-DA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2015 02:11 PM, Ard Biesheuvel wrote:
> Actually, if clang is guaranteed to emit the correct register name
> inside the inline asm for register asm variables used in input or
> output constraints, I think it makes sense to #define __asmeq as a nop
> if __clang__ is defined. (Note that __asmeq only exists to work around
> a specific GCC bug)

I agree completely.  Behan, what do you think?	-Alex
