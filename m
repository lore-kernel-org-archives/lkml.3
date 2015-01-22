Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbbAVUgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:36:00 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:61786 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbbAVUf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:35:58 -0500
MIME-Version: 1.0
In-Reply-To: <CACxGe6sDFQQfiN0+d5HV7JPE-0bosqdaKqrS-7o-obCy1NP_qg@mail.gmail.com>
References: <1421250356-16690-1-git-send-email-geert+renesas@glider.be>
	<20150122161446.101EBC40A80@trevor.secretlab.ca>
	<CACxGe6sDFQQfiN0+d5HV7JPE-0bosqdaKqrS-7o-obCy1NP_qg@mail.gmail.com>
Date: Thu, 22 Jan 2015 21:35:56 +0100
X-Google-Sender-Auth: 2Q8MX7GfLvI7CCToIMfLNd6kmNc
Message-ID: <CAMuHMdU+sQCxaZsV0KthWkuPrFseqtQZb1j+Emn1CShXh4VdnQ@mail.gmail.com>
Subject: Re: [PATCH] of: Add missing of_node_put() in of_find_node_by_path()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Gaurav Minocha <gaurav.minocha.os@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Thu, Jan 22, 2015 at 5:18 PM, Grant Likely <grant.likely@linaro.org> wrote:
> On Thu, Jan 22, 2015 at 4:14 PM, Grant Likely <grant.likely@linaro.org> wrote:
>> On Wed, 14 Jan 2015 16:45:56 +0100
>> , Geert Uytterhoeven <geert+renesas@glider.be>
>>  wrote:
>>> When traversing all nodes and moving to a new path component, the old
>>> one must be released by calling of_node_put(). Else the refcounts of the
>>> parent node(s) will not be decremented.
>>>
>>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>>> ---
> [...]
>>> Feel free to (ab)use the code below and derive a unittest from it...
>
> BTW, can you do this please? They are pretty important for core
> changes now, and I'm stuck with doing them if the person supplying a
> patch does not (and I'm already too much of a bottleneck on the DT
> code).

I'll see whether I can get to it...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
