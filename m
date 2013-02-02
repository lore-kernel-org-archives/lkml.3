Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636Ab3BBFyg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 00:54:36 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:59636 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab3BBFye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 00:54:34 -0500
MIME-Version: 1.0
In-Reply-To: <CANOOhLSSXPuLG5X=TCfThjwcR3GuR=Z-O5qmY4StJZzg+Er5tA@mail.gmail.com>
References: <1359744343-18690-1-git-send-email-dirk.brandewie@gmail.com>
	<1359744343-18690-5-git-send-email-dirk.brandewie@gmail.com>
	<CAOh2x=mSFkTCU1WywdJAyuX4+Z_8EWzFt0z-f8nOfdi1A-wY2Q@mail.gmail.com>
	<CANOOhLSSXPuLG5X=TCfThjwcR3GuR=Z-O5qmY4StJZzg+Er5tA@mail.gmail.com>
Date: Sat, 2 Feb 2013 11:24:33 +0530
Message-ID: <CAKohpom+HXddYC32HYotCsaHGKsH2LXxk0BKNb5kzpqP1UhYGA@mail.gmail.com>
Subject: Re: [PATCH 3/6] cpufreq: Do not track governor name for scaling
 drivers with internal governors.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 February 2013 11:14, Dirk Brandewie <dirk.brandewie@gmail.com> wrote:
> Hi viresh,
>
> This is based on 3.8-rc5.  I think this should work against bleeding_edge
> but I have not tested against bleeding_edge

Rafael wouldn't be able to apply these patches. There are a lot of core patches
present in bleeding_edge.
