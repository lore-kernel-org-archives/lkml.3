Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbaB0MVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:21:03 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:37233 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbaB0MU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:20:59 -0500
MIME-Version: 1.0
In-Reply-To: <20140227110841.GB9987@twins.programming.kicks-ass.net>
References: <20140225173946.GH24636@pd.tnic>
	<CABPqkBTk+KA2kd7Qge2SkNXebDoh9Ntc2L_E3p2k42sbMxoYXw@mail.gmail.com>
	<20140225221027.GB21559@pd.tnic>
	<CABPqkBSH-cHDZ16y0WMyJ2e-kmJ6G_8DkJXPDa7pc4Hp63xG4g@mail.gmail.com>
	<20140226092903.GA22639@pd.tnic>
	<CABPqkBTxQpihn574NArDri0q8ZAOZxXSCSTBfoYfnSxjUH6q6g@mail.gmail.com>
	<20140226095956.GB22639@pd.tnic>
	<CABPqkBS04H6GOT4prZ3v=YZMdj=3KHkW77ON67p8f_Wor17kpw@mail.gmail.com>
	<20140227103031.GA9987@twins.programming.kicks-ass.net>
	<CABPqkBSKH0SGHiWh77ef5eDF7f+4sRmjOppDZzdHSvGs=QQOAg@mail.gmail.com>
	<20140227110841.GB9987@twins.programming.kicks-ass.net>
Date: Thu, 27 Feb 2014 13:20:58 +0100
Message-ID: <CABPqkBTxm-yBRaNNGOk+zxdfTDY2QMfmutu6JvdpjnmJ_0yE9Q@mail.gmail.com>
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        x86 <x86@kernel.org>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 12:08 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Feb 27, 2014 at 11:32:58AM +0100, Stephane Eranian wrote:
>> On Thu, Feb 27, 2014 at 11:30 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Thu, Feb 27, 2014 at 11:12:32AM +0100, Stephane Eranian wrote:
>> >> As a asides, my SNB and HSW desktops with 3.14-rc4 are totally unstable.
>> >> They  hang if I type make in my kernel tree. Whereas 3.14-rc3 is stable. I am
>> >> not so sure this is all related to the uncore IMC support, though.
>> >
>> > Unstable with 3.14-rc4-tip you mean? Yeah, there's a rather crucial
>> > patch missing. I'll try and get Thomas to merge it if Ingo doesn't show
>> > up soon.
>>
>> Yes, I mean from tip.git.
>
> lkml.kernel.org/r/20140224121218.GR15586@twins.programming.kicks-ass.net
>
> Should cure things; unless there's more borkage.

Works again now with your patch.
Thanks.
