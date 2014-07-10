Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaGJHeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 03:34:37 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:53609 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaGJHef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 03:34:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140709233248.GA12171@kroah.com>
References: <1404919578-4457-1-git-send-email-geert+renesas@glider.be>
	<20140709233248.GA12171@kroah.com>
Date: Thu, 10 Jul 2014 09:34:33 +0200
X-Google-Sender-Auth: bjomnYqp2Sk7vPaI-E7hFSswKiI
Message-ID: <CAMuHMdUCo8xmRnSPcUeCVwuWf-9MEWMh+BbnThA2H4nVTv0-KA@mail.gmail.com>
Subject: Re: [PATCH] Documentation: devres: Sort managed interfaces
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thu, Jul 10, 2014 at 1:32 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Jul 09, 2014 at 05:26:18PM +0200, Geert Uytterhoeven wrote:
>> Sort the list of managed interfaces and their lists of methods
>> alphabetically, to reduce the risk of merge conflicts and duplicates.
>>
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> ---
>> I got annoyed by the merge conflicts when merging several for-next
>> branches a while ago, so I sorted the list after everything became
>> quiet.
>> ---
>>  Documentation/driver-model/devres.txt | 108 +++++++++++++++++-----------------
>>  1 file changed, 54 insertions(+), 54 deletions(-)
>
> What tree/version is this against?  I get merge issues with my
> driver-core-next tree :(

Ah, I hadn't merged in your driver-core-next tree.
So it's against v3.16-rc4.

You have on top:

commit b23b35445ec82cde8afac8ba86b57a66a5fa1734
Author: Daniel Thompson <daniel.thompson@linaro.org>
Date:   Thu Jul 3 10:05:02 2014 +0100

    Documentation: devres: Add devm_kmalloc() et al

commit c9d53c0f2d23c792e4b9cf1551b63de4516f839e
Author: Jingoo Han <jg1.han@samsung.com>
Date:   Wed Jun 11 14:00:05 2014 +0900

    devres: remove devm_request_and_ioremap()

Shall I update and resend?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
