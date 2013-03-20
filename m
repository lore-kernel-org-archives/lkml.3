Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab3CTFQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 01:16:24 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:52750 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab3CTFQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 01:16:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohponm_NpYJVcMVcXfMrn+cOFH6OZ2AnWSsVVeSzpmzLM4DQ@mail.gmail.com>
References: <cover.1362381470.git.viresh.kumar@linaro.org>
	<3174774.7AKCbYrzc6@vostro.rjw.lan>
	<CAKohpokwdtSwQmcK=gb2mpzjzp0vpbS7Sra-EhM3QsiQwpog1w@mail.gmail.com>
	<1409962.M4gLo8y6eX@vostro.rjw.lan>
	<CAKohponm_NpYJVcMVcXfMrn+cOFH6OZ2AnWSsVVeSzpmzLM4DQ@mail.gmail.com>
Date: Wed, 20 Mar 2013 10:46:21 +0530
Message-ID: <CAKohpo=RsUoc+uoy9wmQ1vyg7gE-Gad0QvPukNpGRmOPHrtapQ@mail.gmail.com>
Subject: Re: [PATCH V3 4/4] cpufreq: Add Kconfig option to enable/disable have_multiple_policies
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 March 2013 09:53, Viresh Kumar <viresh.kumar@linaro.org> wrote:

> But when do you want me to call this function

Guess what, i got answer to this question: struct cpufreq_driver :)
