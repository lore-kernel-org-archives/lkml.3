Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbaAVFX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 00:23:56 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:43219 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaAVFXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 00:23:55 -0500
MIME-Version: 1.0
In-Reply-To: <20140122045937.GB23869@kroah.com>
References: <1390110907-29918-1-git-send-email-sj38.park@gmail.com>
 <20140119173712.GA26481@kroah.com> <CAPtuhTikj38yKy-=uF7O+VFG_N4AWee23f9woemM318fM3V4VQ@mail.gmail.com>
 <CAEjAshoh5ucPJA6pG1sx+7HGCYjHzCKtbzmH+GYJwpefDYLwJg@mail.gmail.com>
 <CAEjAshozB4S0ZGqEn41ROfZwGTV+_GZRRTZ8cssi0VdH8Uhr_w@mail.gmail.com> <20140122045937.GB23869@kroah.com>
From: SeongJae Park <sj38.park@gmail.com>
Date: Wed, 22 Jan 2014 14:23:34 +0900
Message-ID: <CAEjAshrxXLJ-zFsTO9TnewYBBEPzFR1cixbLnD6U-U1EKdByxg@mail.gmail.com>
Subject: Re: [PATCH] clk: export __clk_get_hw for re-use in others
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 1:59 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Jan 22, 2014 at 12:05:57PM +0900, SeongJae Park wrote:
>> Dear Greg, Mike,
>>
>> May I ask your answer or other opinion, please?
>
> It's the middle of the merge window, it's not time for new development,
> or much time for free-time for me, sorry.  Feel free to fix it the best
> way you know how.

Oops, I've forgot about the merge window. Thank you very much for your
kind answer.
Sorry if I bothered you while you're in busy time.
Because the build problem is not a big deal because it exists only in
-next tree,
I will wait until merge window be closed and then fix it again if it
still exist.

SeongJae Park.
>
> greg k-h
