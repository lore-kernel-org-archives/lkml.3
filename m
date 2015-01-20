Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbbATQGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:06:00 -0500
Received: from unicorn.mansr.com ([81.2.72.234]:41471 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbbATQF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:05:58 -0500
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Rob Herring <robherring2@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] of: Custom printk format specifier for device node
References: <1421764441-11928-1-git-send-email-pantelis.antoniou@konsulko.com>
	<CAL_JsqLVJjq3Ov=J-5LtXiTQPLvR5Y=+tB1i16k_rN3j5dODFQ@mail.gmail.com>
	<CAMuHMdWnjawtgkKGuL8b4A17EhDS6B0L-1_uhSnvEXXk5dNjwQ@mail.gmail.com>
	<25E49021-E94D-4DFA-AC37-1D4A3AAE9F88@konsulko.com>
Date: Tue, 20 Jan 2015 16:05:54 +0000
In-Reply-To: <25E49021-E94D-4DFA-AC37-1D4A3AAE9F88@konsulko.com> (Pantelis
	Antoniou's message of "Tue, 20 Jan 2015 17:27:42 +0200")
Message-ID: <yw1x8ugxe8t9.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pantelis Antoniou <pantelis.antoniou@konsulko.com> writes:

> Hi Geert,
>
>> On Jan 20, 2015, at 17:24 , Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> 
>> On Tue, Jan 20, 2015 at 3:47 PM, Rob Herring <robherring2@gmail.com> wrote:
>>>> +       Examples:
>>>> +
>>>> +       %pO     /foo/bar@0              - Node full name
>>>> +       %pO0    /foo/bar@0              - Same as above
>>>> +       %pO1    /foo/bar@0[10]          - Node full name + phandle
>>>> +       %pO2    /foo/bar@0[10:DdPB]     - Node full name + phandle + node flags
>>>> +                                        D - dynamic
>>>> +                                        d - detached
>>>> +                                        P - Populated
>>>> +                                        B - Populated bus
>>> 
>>> We should think about what else we want to print for a node. Perhaps
>>> 'On' for name, 'Oc' for compatible, etc.
>> 
>> I was just going to say "The least verbose variant is name, not full_name”.
>> 
>
> Unfortunately in the context of device tree nodes ‘name' is usually
> not what you want to print to identify the node in question. ‘name’ is
> usually not unique.

Name and address without the full path is usually a good compromise
between uniqueness (it is usually unique for memory-mapped things) and
verbosity.

-- 
Måns Rullgård
mans@mansr.com
