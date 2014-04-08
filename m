Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbaDHEIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 00:08:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36182 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaDHEIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 00:08:16 -0400
MIME-Version: 1.0
In-Reply-To: <53434A4E.2050407@gmail.com>
References: <53429445.5000005@gmail.com>
	<CAKohpok189SxuJoGNvgshwEaUozMDM9mzA8wse5COkN8MBUaPg@mail.gmail.com>
	<53434A4E.2050407@gmail.com>
Date: Tue, 8 Apr 2014 09:38:16 +0530
Message-ID: <CAKohponSStjFJyKt7Yy7EX1wfk3xbJxoXpt47qStcSGfQVK7aw@mail.gmail.com>
Subject: Re: [PATCH] drivers:cpufreq:unicore32: fix typo issue for 'clk'
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 April 2014 06:31, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
>> @stable: please apply this for v3.14, as it broke in that cycle..

This wouldn't work..

> Thank you.

Can you please send it again for stable as well? Add my Ack in the patch
and follow what's mentioned here:

Documentation/stable_kernel_rules.txt
