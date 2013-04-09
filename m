Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765493Ab3DIOUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:20:48 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:52741 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765085Ab3DIOUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:20:47 -0400
MIME-Version: 1.0
In-Reply-To: <51641ED3.1090603@samsung.com>
References: <1365500744-14839-1-git-send-email-gautam.vivek@samsung.com>
	<5163E8EB.1050803@samsung.com>
	<CAFp+6iE-ZYSNHZBntTcX8fESLB2FXOr6idM8_Q3Rd7T3s_c4Dw@mail.gmail.com>
	<CAFp+6iGS-4iv-PKTKP4OhwVvTsDoPnc-9N-6AAr5x=Bz9r=vTw@mail.gmail.com>
	<51641ED3.1090603@samsung.com>
Date: Tue, 9 Apr 2013 19:50:45 +0530
Message-ID: <CAFp+6iH1+dtfijt2Hf6k7jT8irgS63_32oUpPaOZ=CPNa88tUA@mail.gmail.com>
Subject: Re: [PATCH RFC] rtc: rtc-s3c: use clk_prepare_enable and clk_disable_unprepare
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        a.zummo@towertech.it, kgene.kim@samsung.com, dianders@chromium.org,
        Thomas Abraham <thomas.ab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 7:29 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> On 04/09/2013 03:34 PM, Vivek Gautam wrote:
>>> Aah !! actually missed a similar patch from Thomas Abraham :(
>>> > doing the same as suggested by you.
>>> > Its available at:
>>> > http://patchwork.ozlabs.org/patch/188687/
>> There's a change required in the above mentioned patch, so possibly
>> Thomas can go ahead and post the next version
>> of that.
>
> Why not make that change yourself if you need it ? That patch is
> really old, maybe Thomas is busy with other things now.

Sure, will post a patch fixing this. :-)


-- 
Thanks & Regards
Vivek
