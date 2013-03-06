Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab3CFNhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:37:52 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:52094 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab3CFNhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:37:50 -0500
MIME-Version: 1.0
In-Reply-To: <1362521727-20666-1-git-send-email-dirk.brandewie@gmail.com>
References: <1362521727-20666-1-git-send-email-dirk.brandewie@gmail.com>
Date: Wed, 6 Mar 2013 21:37:48 +0800
X-Google-Sender-Auth: MEuwBGPIfIE7XZ-kz_5Ji0arjqc
Message-ID: <CAOh2x=m=myFE=2=74U2XNew6FsbDichwhGTTQOyvrnayHicHzA@mail.gmail.com>
Subject: Re: [PATCH 0/2] v3.9-rc1 fixes for intel_pstate driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        konrad.wilk@oracle.com, jwboyer@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 6, 2013 at 6:15 AM,  <dirk.brandewie@gmail.com> wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>
> These patches fix the issues reported against the intel_pstate driver.
>
> The first bug reported by Josh Boyer was that the dirver would blow up

s/dirver/driver :)

> when loading in a VM exposed the second bug that the error path in
> intel_pstate_init() was incorrect and biting Konrad Wilk as well.
>
> https://bugzilla.redhat.com/show_bug.cgi?id=916833
> https://lkml.org/lkml/2013/3/5/394

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
