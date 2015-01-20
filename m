Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbbATPYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:24:05 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:56879 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbbATPYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:24:02 -0500
MIME-Version: 1.0
In-Reply-To: <CAL_JsqLVJjq3Ov=J-5LtXiTQPLvR5Y=+tB1i16k_rN3j5dODFQ@mail.gmail.com>
References: <1421764441-11928-1-git-send-email-pantelis.antoniou@konsulko.com>
	<CAL_JsqLVJjq3Ov=J-5LtXiTQPLvR5Y=+tB1i16k_rN3j5dODFQ@mail.gmail.com>
Date: Tue, 20 Jan 2015 16:24:00 +0100
X-Google-Sender-Auth: fT2tQtjqoQi8tPHFtqP8wG-1OzQ
Message-ID: <CAMuHMdWnjawtgkKGuL8b4A17EhDS6B0L-1_uhSnvEXXk5dNjwQ@mail.gmail.com>
Subject: Re: [PATCH] of: Custom printk format specifier for device node
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 3:47 PM, Rob Herring <robherring2@gmail.com> wrote:
>> +       Examples:
>> +
>> +       %pO     /foo/bar@0              - Node full name
>> +       %pO0    /foo/bar@0              - Same as above
>> +       %pO1    /foo/bar@0[10]          - Node full name + phandle
>> +       %pO2    /foo/bar@0[10:DdPB]     - Node full name + phandle + node flags
>> +                                        D - dynamic
>> +                                        d - detached
>> +                                        P - Populated
>> +                                        B - Populated bus
>
> We should think about what else we want to print for a node. Perhaps
> 'On' for name, 'Oc' for compatible, etc.

I was just going to say "The least verbose variant is name, not full_name".

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
