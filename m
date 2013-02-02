Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab3BBDZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 22:25:55 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:37329 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757449Ab3BBDZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 22:25:53 -0500
MIME-Version: 1.0
In-Reply-To: <1359744343-18690-5-git-send-email-dirk.brandewie@gmail.com>
References: <1359744343-18690-1-git-send-email-dirk.brandewie@gmail.com>
	<1359744343-18690-5-git-send-email-dirk.brandewie@gmail.com>
Date: Sat, 2 Feb 2013 08:55:52 +0530
X-Google-Sender-Auth: HVlUSGfk8NMKbLzVHHYwL54GDGA
Message-ID: <CAOh2x=mSFkTCU1WywdJAyuX4+Z_8EWzFt0z-f8nOfdi1A-wY2Q@mail.gmail.com>
Subject: Re: [PATCH 3/6] cpufreq: Do not track governor name for scaling
 drivers with internal governors.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 2, 2013 at 12:15 AM,  <dirk.brandewie@gmail.com> wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>
> Scaling drivers that implement internal governors do not have governor
> structures assocaited with them.  Only track the name of the governor
> associated with the CPU if the driver does not implement
> cpufreq_driver.setpolicy()
>
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>

Is this rebased on latest stuff? i.e. rafael/bleeding_edge ?

--
viresh
