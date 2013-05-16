Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab3EPNuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 09:50:05 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:46800 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab3EPNuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 09:50:02 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrXA-nbdDEv1TyU9e4mcGZzAoCTTDX33M1o31rZkgHHTFg@mail.gmail.com>
References: <cover.1368485053.git.luto@amacapital.net>
	<bf7788cfd4695d05f2b414735744105906650e42.1368485053.git.luto@amacapital.net>
	<CADnq5_O6tZeRVq=gmJfn3JWQGgECSE1JuonpSKgFCYSD8RCqHQ@mail.gmail.com>
	<CAH3drwbSLdjd4Y8x8YfzhM5WK+A-L7mnYeS0kdqu7MwEB5kbCQ@mail.gmail.com>
	<CALCETrVo-6cnKZsDJnBJcwGjpPbW9QAYriyjAZavaZ8O2OkjnQ@mail.gmail.com>
	<CAH3drwb743_q5ZrNDNsnOUUNVDMcefaq9NH3+t863OGc98-D-Q@mail.gmail.com>
	<CALCETrXA-nbdDEv1TyU9e4mcGZzAoCTTDX33M1o31rZkgHHTFg@mail.gmail.com>
Date: Thu, 16 May 2013 09:50:01 -0400
Message-ID: <CAH3drwY0vVGnf05v-coSmS4OQyHuufycLojEn9que6iL_r3AUw@mail.gmail.com>
Subject: Re: [PATCH v3 6/9] radeon: Switch to arch_phys_wc_add and add a
 missing ..._del
From: Jerome Glisse <j.glisse@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Alex Deucher <alexdeucher@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 2:22 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Wed, May 15, 2013 at 7:49 AM, Jerome Glisse <j.glisse@gmail.com> wrote:
>> On Tue, May 14, 2013 at 5:35 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> On Tue, May 14, 2013 at 6:37 AM, Jerome Glisse <j.glisse@gmail.com> wrote:
>>>> On Tue, May 14, 2013 at 8:58 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
>>>>> On Mon, May 13, 2013 at 7:58 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>>>> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>>>>>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>>>>>
>>>>> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
>>>>
>>>> I believe it will break something but we could deal with the fallout
>>>> once it happens.
>>>
>>> FWIW, I'm running with this code on my machine right now using the
>>> radeon driver.  Everything seems fine.  If I build without MTRRs and
>>> without PAT, though, graphics are slow (as expected).  So I think
>>> everything's okay.
>>>
>>> --Andy
>>
>> I am worried on p4 where i last see issue with that notably with agp.
>
> Do you remember any details?  It looks like PAT is enabled on Pentium
> 4 (i.e. famliy 0xF).
>
> --Andy

No i don't, i think it was some pat errata on those about non real ram
address and with agp. Memory is fuzzy. I might have time in couple of
week to plug back my p4 and see how it behave.

Cheers,
Jerome
