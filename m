Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368Ab3FRR2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:28:25 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:33440 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933011Ab3FRR2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:28:22 -0400
MIME-Version: 1.0
In-Reply-To: <51C08B01.40200@zytor.com>
References: <1371154622-8929-1-git-send-email-yinghai@kernel.org>
	<51C08B01.40200@zytor.com>
Date: Tue, 18 Jun 2013 10:28:22 -0700
X-Google-Sender-Auth: CBmd7MslXzhBz9RodbJ16KUmLpE
Message-ID: <CAE9FiQXM=mgvUqLh_Uj9NA8fMOSt+zCz-ev-ujnVkhHm8fQW_g@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] x86, mtrr: fixs for mtrr_cleanup
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Joshua Covington <joshuacov@googlemail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 9:29 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> On this subject: what do we need to happen to be able to dump the MTRR
> cleanup stuff?

the old x server like to add Write-combining entry in MTRR.
looks like drm for mga200 is adding that too ?

We need to make them to use PAT instead.

Yinghai
