Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410Ab3ECGx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:53:56 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:37007 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933388Ab3ECGxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:53:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130503110318.0d30b773852640ee94ba07b5@canb.auug.org.au>
References: <51823DDA.7010103@nvidia.com> <20130503105234.6e9c8aa5ed2784bbe084caa8@canb.auug.org.au>
 <20130503110318.0d30b773852640ee94ba07b5@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 3 May 2013 07:53:34 +0100
X-Google-Sender-Auth: NN1FMg89TsuD8op9Zu3-V2uQS0k
Message-ID: <CACxGe6tdJr22bJ0GZL_18FqYWLdNROMKuH3UQbKciEwRy9v1Wg@mail.gmail.com>
Subject: Re: [GIT PULL] Removal of GENERIC_GPIO
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alex Courbot <acourbot@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 2:03 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Guys,
>
> On Fri, 3 May 2013 10:52:34 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> I currently have 3 merge fix patches for the gen-cpio tree:
>>
>> gen-gpio: GPIOLIB merge fix up
>> merge fix for Convert selectors of GENERIC_GPIO to GPIOLIB
>> merge fix 2 for Convert selectors of GENERIC_GPIO to GPIOLIB
>>
>> I have attached them.  All three are now applicable to Linus' tree.
>
> Just to absolutely clear, I *do not* expect either of you to rebase your
> trees or backmerge Linus' tree to fix these, I *do* expect whoever send
> this stuff to Linus to mention the necessary fixes to him.

Yes, that is exactly what I'm going to do

g.
