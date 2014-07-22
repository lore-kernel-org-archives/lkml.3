Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbaGVSDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 14:03:41 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49133 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaGVSDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 14:03:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140722174610.GA9284@pd.tnic>
References: <1406004789-9918-1-git-send-email-xerofoify@gmail.com>
	<874my98p6u.fsf@nemi.mork.no>
	<CA+8MBb+fnCNeQtyEqttxbkWx-4N+GUaKCUoCSdn5X9+bDDvTOg@mail.gmail.com>
	<CAPDOMVjaf+vne4vbUPo8EPs0XnQBbNm2ZOXns8fw5pkg9tRSww@mail.gmail.com>
	<20140722174610.GA9284@pd.tnic>
Date: Tue, 22 Jul 2014 14:03:38 -0400
Message-ID: <CAPDOMVg7qDOf4U4eoOLOrY1mEtqzRgSrJ3HOd4QcBXsnV8wU1Q@mail.gmail.com>
Subject: Re: [PATCH] edac: Remove fixmes in e7xxx_edac.c
From: Nick Krause <xerofoify@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@gmail.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Doug Thompson <dougthompson@xmission.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 1:46 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Jul 22, 2014 at 01:40:42PM -0400, Nick Krause wrote:
>> What is the value of Page shift then ? If you can tell me it would be
>> much easier for
>> me to fix this.
>
> I'll give you a rat's ass if you find that out on your own.
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
Page shift is 12 for 4k pages.
Nick
