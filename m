Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587Ab3ENVf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 17:35:29 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:57122 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758541Ab3ENVf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 17:35:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAH3drwbSLdjd4Y8x8YfzhM5WK+A-L7mnYeS0kdqu7MwEB5kbCQ@mail.gmail.com>
References: <cover.1368485053.git.luto@amacapital.net> <bf7788cfd4695d05f2b414735744105906650e42.1368485053.git.luto@amacapital.net>
 <CADnq5_O6tZeRVq=gmJfn3JWQGgECSE1JuonpSKgFCYSD8RCqHQ@mail.gmail.com> <CAH3drwbSLdjd4Y8x8YfzhM5WK+A-L7mnYeS0kdqu7MwEB5kbCQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 14 May 2013 14:35:04 -0700
Message-ID: <CALCETrVo-6cnKZsDJnBJcwGjpPbW9QAYriyjAZavaZ8O2OkjnQ@mail.gmail.com>
Subject: Re: [PATCH v3 6/9] radeon: Switch to arch_phys_wc_add and add a
 missing ..._del
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Alex Deucher <alexdeucher@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 6:37 AM, Jerome Glisse <j.glisse@gmail.com> wrote:
> On Tue, May 14, 2013 at 8:58 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
>> On Mon, May 13, 2013 at 7:58 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>>
>> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
>
> I believe it will break something but we could deal with the fallout
> once it happens.

FWIW, I'm running with this code on my machine right now using the
radeon driver.  Everything seems fine.  If I build without MTRRs and
without PAT, though, graphics are slow (as expected).  So I think
everything's okay.

--Andy
