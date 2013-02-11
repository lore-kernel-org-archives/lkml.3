Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762Ab3BKTIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 14:08:42 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:33602 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758530Ab3BKTIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 14:08:40 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:ae16:2dff:fe07:4e83]
In-Reply-To: <20130211185221.GR4801@atomide.com>
References: <20130211170616.73fd9fd30bb10c27a698ad4d@canb.auug.org.au>
	<20130211185221.GR4801@atomide.com>
Date: Mon, 11 Feb 2013 11:08:38 -0800
Message-ID: <CAOesGMi5xCahJ=5emwxiXeKEZkK4yhctcTddPZNQXO5wzcdQwQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the mfd tree
From: Olof Johansson <olof@lixom.net>
To: Tony Lindgren <tony@atomide.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roger Quadros <rogerq@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Paul Walmsley <paul@pwsan.com>,
        Felipe Balbi <balbi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 10:52 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Stephen Rothwell <sfr@canb.auug.org.au> [130210 22:11]:
>> Hi all,
>>
>> Today's linux-next merge of the arm-soc tree got a conflict in
>> arch/arm/mach-omap2/usb-host.c between commit 8a89e93237e1 ("mfd:
>> omap-usb-host: Consolidate OMAP USB-HS platform data") from the mfd tree
>> and commit c1d1cd597fc7 ("ARM: OMAP2+: omap_device: remove obsolete
>> pm_lats and early_device code") from the arm-soc tree.
>>
>> I fixed it up (see below) and can carry the fix as necessary (no action
>> is required).
>
> Thanks again.
>
> Samuel, up to you, but I suggest you just drop these patches for
> now if still possible unless other patches are based on these.

Yes, as I replied on the original patch series last night, please sort
this out so we can avoid these nagging merge conflicts. Tony's steps
in the previous email is the right way to handle these kind of things.


-Olof
