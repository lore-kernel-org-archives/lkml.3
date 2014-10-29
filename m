Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933849AbaJ2PWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:22:21 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:53662 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194AbaJ2PWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:22:19 -0400
MIME-Version: 1.0
In-Reply-To: <20141029142214.GS12020@console-pimps.org>
References: <1411313216-2641-2-git-send-email-minipli@googlemail.com>
	<20141003134707.GJ14343@console-pimps.org>
	<20141007150132.GA7307@nazgul.tnic>
	<20141007170748.GA25767@jig.fritz.box>
	<20141008151730.GB16892@pd.tnic>
	<CA+rthh_Q0HQfLX6P3kcuOUwggjSnhYGCc5YJNOn0UCCRPZbaxA@mail.gmail.com>
	<20141008222619.GG16892@pd.tnic>
	<20141012125515.GA32045@jig.fritz.box>
	<20141028185756.GD10873@pd.tnic>
	<CA+rthh9qePkJogFDT+ttSLvYPvJrAM6CXMJ407Hq3PjcRw9WTw@mail.gmail.com>
	<20141029142214.GS12020@console-pimps.org>
Date: Wed, 29 Oct 2014 16:22:17 +0100
Message-ID: <CA+rthh8yf2PONJzoJrQ_vQjfaVbJj2e9TFvrK1YDdnL5_gspFQ@mail.gmail.com>
Subject: Re: [PATCHv2 1/3] x86, ptdump: Add section for EFI runtime services
From: Mathias Krause <minipli@googlemail.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86-ml <x86@kernel.org>, Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 October 2014 15:22, Matt Fleming <matt@console-pimps.org> wrote:
> On Tue, 28 Oct, at 08:48:23PM, Mathias Krause wrote:
>> On 28 October 2014 19:57, Borislav Petkov <bp@alien8.de> wrote:
>> > [...]
>> >
>> > Ok, thanks for refreshing this for me, your patch is good, so
>> >
>> > Acked-by: Borislav Petkov <bp@suse.de>
>>
>> Thanks. But as you said, the EFI mappings shouldn't be in the kernel's
>> page table in the first place, so I'd rather see a patch doing that
>> instead. But, in the meantime, this patch is valid, as it shows the
>> "status quo".
>
> Now, everyone agrees this patch is OK? There are no comments that still
> need addressing?

The patch was fine from the beginning. The discussion kind of hijacked
the thread to argue about the underlying issue. So, the patch is still
good for me to be merged.

Thanks,
Mathias
