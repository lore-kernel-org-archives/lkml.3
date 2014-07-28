Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaG1PJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:09:19 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:55439 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaG1PJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:09:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140728095442.GA4875@fancy-poultry.org>
References: <CAPDOMViYi_rg_cGp_SgZVqX6pw+SB=CVbr1kFn5WG481s4tz5A@mail.gmail.com>
	<20140727083758.GA4834@fancy-poultry.org>
	<CAPDOMVgjLU+r82eKFA=4-v_oS+4c4fCtovcZMer5x5GAW56DSw@mail.gmail.com>
	<20140728095442.GA4875@fancy-poultry.org>
Date: Mon, 28 Jul 2014 11:09:16 -0400
Message-ID: <CAPDOMViPdBnkLH2t=1zGAyB98bNGfZrxLvDngDrDQHYP+uCuqg@mail.gmail.com>
Subject: Re: Bug on Kernel 3.16 r6: Sound and Buffering in Clementine with
 Files are Transferring to Music Directory
From: Nick Krause <xerofoify@gmail.com>
To: Heinz Diehl <htd@fancy-poultry.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 5:54 AM, Heinz Diehl <htd@fancy-poultry.org> wrote:
> First: my email you are quoting here was sent to you directly, off-list,
> because it only contains common stuff and has nothing to do with
> kernel development. In other words to avoid annoying lkml people.
> In addition, I placed an "Reply-to" header pointing back to me.
> Despite, you *manually* redirected your answer to my private mail
> back to the list, thus annoying people and breaking the informational
> flow of this thread.
>
>
> On 27.07.2014, Nick Krause wrote:
>
>> I am transferring into the same directory for the music
>> I am listening to.
>
> So you produce a lot of disk I/O by writing/reading from the same disk
> at the same time, and as you encounter stalls, you take this for a
> kernel bug (which clearly is not). These stalls are most probably
> caused by fsync() flushing your data/buffers, which is blocking.
>
> So moving the music data you are listening to to another disk would
> make things a lot easier.
>
>> In addition , my cpu usage when doing this is half of my older
>
> DMA transfer is mostly done be the controller itself, and not the CPU.
>
> Btw, EOT for me.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


Then explain to me why this is only happening on recent rc kernels and not
the Ubuntu distro kernels I was using before. Seems weird that only
recent rc kernels are triggering this.
Regards Nick
