Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab3B1GFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 01:05:09 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:62978 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab3B1GFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 01:05:06 -0500
MIME-Version: 1.0
In-Reply-To: <87lia9rnah.fsf@sejong.aot.lge.com>
References: <1362029882-28993-1-git-send-email-namhyung@kernel.org>
	<1362029882-28993-3-git-send-email-namhyung@kernel.org>
	<CAKohpomiG1G2NUScDpzbqTBJAOfNr3PcWe55PoGK8bvY4tCdMw@mail.gmail.com>
	<87lia9rnah.fsf@sejong.aot.lge.com>
Date: Thu, 28 Feb 2013 11:35:04 +0530
Message-ID: <CAKohpoksRRLmEcpA5g23ZsMmvovVh3=m3sqVUPZqs-j5xQ-V6Q@mail.gmail.com>
Subject: Re: [PATCH -next 3/3] cpufreq: conservative: Fix relation when
 decreasing frequency
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 February 2013 11:29, Namhyung Kim <namhyung@kernel.org> wrote:
> When decreasing, we were on a higher frequency than target so selecting
> above or equal to the target frequency seems to be "conservative".

I will buy that. For all three patches:

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
