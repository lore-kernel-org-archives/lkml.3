Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab3JYIWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 04:22:14 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:55643 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab3JYIWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 04:22:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM=9tzThUmwO1Pw6PvtUvM7ywDzWGSF23wCEVS=wMa3PVNEPw@mail.gmail.com>
References: <20131024132734.GB2634@kernel.dk>
	<CAPM=9tzThUmwO1Pw6PvtUvM7ywDzWGSF23wCEVS=wMa3PVNEPw@mail.gmail.com>
Date: Fri, 25 Oct 2013 09:22:10 +0100
Message-ID: <CAPM=9ty+xi=1DFWWy8zzS870TTe7Hny948LoPS_pmDAzMGrqtQ@mail.gmail.com>
Subject: Re: 3.12-rc6 nouveau oops
From: Dave Airlie <airlied@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Dave Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 8:59 AM, Dave Airlie <airlied@gmail.com> wrote:
>> Booting 3.12-rc6 on my macbook quickly freezes after logging in to X. I
>> was able to capture this oops. It's 100% consistent. 3.11 works
>> perfectly fine, as did previous kernels.
>
> Can you boot with nouveau.runpm=0 and see if it boots and survives
> suspend/resume.
>

Oh also a complete dmesg so we can see the DCB table.

Dave.
