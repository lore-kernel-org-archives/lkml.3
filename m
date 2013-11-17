Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab3KQUtw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 15:49:52 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:59904 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab3KQUtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 15:49:41 -0500
MIME-Version: 1.0
In-Reply-To: <20131117195358.GO27323@pd.tnic>
References: <52888F6D.6000802@gmail.com>
	<20131117132531.GB27696@pd.tnic>
	<5288E5BF.2020608@gmail.com>
	<20131117160126.GG27323@pd.tnic>
	<CAC9WiBikz8kTAmKs1HVBmeb2Wu6hfHCh2d=w1sQC03EVHa1QOQ@mail.gmail.com>
	<20131117195358.GO27323@pd.tnic>
Date: Sun, 17 Nov 2013 21:49:40 +0100
Message-ID: <CAC9WiBggfssh+31_MqVCT-hDf2E8zTuc81q-DhLYQuVF053mEA@mail.gmail.com>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
From: Francis Moreau <francis.moro@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 8:53 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Sun, Nov 17, 2013 at 07:02:21PM +0100, Francis Moreau wrote:
>> Sorry I haven't taken the original picture large enough, and getting
>> this kernel panic is pretty hard since the kernel usually displays the
>> black screen.
>
> Ok, just try to make a readable picture of the whole line, next time you
> trigger it.
>
>> I can't find any traces of this function in the dump...
>
> Hmm, strange. Can you upload the whole vmlinux somewhere? Or is this the
> official archlinux kernel? If so, where can I get it from?

Yes, you can download the bin package from :
https://www.archlinux.org/packages/core/x86_64/linux/

The bin package is a tar archive, so it pretty straightforward to
unpack the vmlinux file  (actual is filename vmlinuz-linux).

Thanks for you help.
-- 
Francis
