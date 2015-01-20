Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbbATP1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:27:51 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:47063 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbbATP1s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:27:48 -0500
Subject: Re: [PATCH] of: Custom printk format specifier for device node
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Content-Type: text/plain; charset=utf-8
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
In-Reply-To: <CAMuHMdWnjawtgkKGuL8b4A17EhDS6B0L-1_uhSnvEXXk5dNjwQ@mail.gmail.com>
Date: Tue, 20 Jan 2015 17:27:42 +0200
Cc: Rob Herring <robherring2@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <25E49021-E94D-4DFA-AC37-1D4A3AAE9F88@konsulko.com>
References: <1421764441-11928-1-git-send-email-pantelis.antoniou@konsulko.com> <CAL_JsqLVJjq3Ov=J-5LtXiTQPLvR5Y=+tB1i16k_rN3j5dODFQ@mail.gmail.com> <CAMuHMdWnjawtgkKGuL8b4A17EhDS6B0L-1_uhSnvEXXk5dNjwQ@mail.gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

> On Jan 20, 2015, at 17:24 , Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> 
> On Tue, Jan 20, 2015 at 3:47 PM, Rob Herring <robherring2@gmail.com> wrote:
>>> +       Examples:
>>> +
>>> +       %pO     /foo/bar@0              - Node full name
>>> +       %pO0    /foo/bar@0              - Same as above
>>> +       %pO1    /foo/bar@0[10]          - Node full name + phandle
>>> +       %pO2    /foo/bar@0[10:DdPB]     - Node full name + phandle + node flags
>>> +                                        D - dynamic
>>> +                                        d - detached
>>> +                                        P - Populated
>>> +                                        B - Populated bus
>> 
>> We should think about what else we want to print for a node. Perhaps
>> 'On' for name, 'Oc' for compatible, etc.
> 
> I was just going to say "The least verbose variant is name, not full_name”.
> 

Unfortunately in the context of device tree nodes ‘name' is usually not what
you want to print to identify the node in question. ‘name’ is usually not unique.

We can add a format specifier for it though.

> Gr{oetje,eeting}s,
> 
>                        Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                -- Linus Torvalds

Regards

— Pantelis

