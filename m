Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbaEGIxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:53:10 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:58330 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104AbaEGIxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:53:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140507084900.GE6362@ulmo>
References: <1399325340-20416-1-git-send-email-b.galvani@gmail.com>
	<CAOh2x=mWqa=p2d1kRjf0_37DiioJZOJm3Ewv2xpMrNjPy69rvA@mail.gmail.com>
	<20140507082410.GC6362@ulmo>
	<CAKohpomkrR715dhyZZQwu_-S6LHsYBOj9YsX9HR6PCMKkMdrVw@mail.gmail.com>
	<20140507084900.GE6362@ulmo>
Date: Wed, 7 May 2014 14:23:06 +0530
Message-ID: <CAKohpomnACpPFytPWDQeeUTRM3yoNPPOHbWQLpsVjF=V_qVm1Q@mail.gmail.com>
Subject: Re: [PATCH] pwm: spear: fix check on pwmchip_add() return value
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Beniamino Galvani <b.galvani@gmail.com>, linux-pwm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 May 2014 14:19, Thierry Reding <thierry.reding@gmail.com> wrote:
> Since this was obviously broken since 3.8 and nobody noticed I wonder if
> there's really an urgent need for this in stable.

I don't think there is any urgent need of this, in case somebody wants we
can add it later. :)
