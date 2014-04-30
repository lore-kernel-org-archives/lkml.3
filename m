Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389AbaD3IvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:51:20 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:59206 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758346AbaD3IvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:51:15 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
Date: Wed, 30 Apr 2014 14:21:15 +0530
Message-ID: <CAKohpok5O_6Bv_q7Xbhzyt15AL-cU4-L9CQj-6sv+_EFwq=Cew@mail.gmail.com>
Subject: Re: [PATCH V2 00/19] tick: cleanups (Shouldn't change code behavior)
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 April 2014 15:24, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> As suggested by you (https://lkml.org/lkml/2014/4/14/797), this is the second
> lot of changes I have. I have divided the earlier patchset into three parts:
> - Bugfixes, already merged
> - Code cleanups which shouldn't have any functional change
> - Code cleanups which may have any functional change
>
> This patchset is targeting the second part now. Its just about moving the code
> around to make it more readable and obvious. Not removing any code at all, that
> will be addressed in next series.
>
> V1->V2: Actually V1 was never reviewed and so it is mostly a resend of V1. Some
> rearrangement of patches is done though.
>
> Viresh Kumar (19):

Hi Thomas,

Any inputs on these ?
