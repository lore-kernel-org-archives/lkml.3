Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389Ab3AOABd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 19:01:33 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:55933 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab3AOABc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 19:01:32 -0500
MIME-Version: 1.0
In-Reply-To: <1358182303.4675.2.camel@mattotaupa>
References: <alpine.LNX.2.00.1301061336180.1397@xoschi>
	<CADnq5_O1GDuigxwR8eXu7f1Fsb8iqrggVwYBaiOJKOR-ighYag@mail.gmail.com>
	<alpine.LNX.2.00.1301072206530.1617@xoschi>
	<CADnq5_NEQ2cCEPEGwBhX1KP0bDn7b+Q2M=Logw1fVC67ct-gEA@mail.gmail.com>
	<alpine.LNX.2.00.1301132143310.1772@xoschi>
	<CADnq5_N+pHZ5ugCDp7EfdW7yZ-ABS3M-vk_xtUFmnqDzz9sBvg@mail.gmail.com>
	<1358182303.4675.2.camel@mattotaupa>
Date: Mon, 14 Jan 2013 19:01:31 -0500
Message-ID: <CADnq5_PZBwR2XnicN7PWM3kRxZ2-fqRzFGbCh+Uhhftv17aLyw@mail.gmail.com>
Subject: Re: Regression: drm/radeon: brightness control hard system lockup
From: Alex Deucher <alexdeucher@gmail.com>
To: Paul Menzel <paulepanter@users.sourceforge.net>
Cc: Eldad Zack <eldad@fogrefinery.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 11:51 AM, Paul Menzel
<paulepanter@users.sourceforge.net> wrote:
> Dear Alex,
>
>
> Am Montag, den 14.01.2013, 11:08 -0500 schrieb Alex Deucher:
>
> […]
>
>> Date: Mon, 14 Jan 2013 11:04:39 -0500
>> Subject: [PATCH] drm/radeon: clear reset flags if engines are idle
>>
>> Fixes a regression
>
> please describe the regression.
>
> »brightness control hard system lockup«
>
>> in the gpu reset code after the rework for DMA support.
>
> and add the corresponding commit, Eldad tracked down. And for
> completeness the URL of the discussion.
>
> This is important for distribution folks to judge if certain commits are
> needed or not. And for users looking through the commit history to spot
> a certain fix.
>>
>> Reported-by: Eldad Zack <eldad@fogrefinery.com>
>> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>
> With the above,
>
> Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>

I'll fix it up when I add it to my next -fixes pull.

Thanks!

Alex

>
>> ---
>>  drivers/gpu/drm/radeon/evergreen.c |    6 ++++++
>>  drivers/gpu/drm/radeon/ni.c        |    6 ++++++
>>  drivers/gpu/drm/radeon/r600.c      |    6 ++++++
>>  drivers/gpu/drm/radeon/si.c        |    6 ++++++
>>  4 files changed, 24 insertions(+), 0 deletions(-)
>
> […]
>
>
> Thanks,
>
> Paul
