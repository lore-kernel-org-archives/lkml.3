Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab3FKFWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 01:22:30 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:41299 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3FKFW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 01:22:28 -0400
MIME-Version: 1.0
In-Reply-To: <51B6B373.7040904@samsung.com>
References: <1370419882-16831-1-git-send-email-cw00.choi@samsung.com>
	<CAKohpon6fgft2KZgy3-w5TxDz=5JsVHhNdTPTF7ZUq9K-kGc3w@mail.gmail.com>
	<51B5C2E4.9060400@samsung.com>
	<CAKohpokSt1=cbeYFo-U_DF5Mr8WOFDkkQbyaHh5DqR0OHh+S7A@mail.gmail.com>
	<51B6B373.7040904@samsung.com>
Date: Tue, 11 Jun 2013 10:52:27 +0530
Message-ID: <CAKohpomNN=keppPeLLDor_6YpyOO19_fsbWZRE+w33DoVDBprw@mail.gmail.com>
Subject: Re: [RESEND][PATCH] cpufreq: stats: Add 'load_table' sysfs file to
 show accumulated data of CPU
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 June 2013 10:49, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> I will modify this patch according to your comment
> and then resend it after merged below patch.
> - [PATCH] cpufreq: stats: Remove CONFIG_CPU_FREQ_STAT_DETAILS

Hmm.. Maybe you can sent it without rebasing your patch over mine and
we can rebase it over my patch later. So, that you don't end up waiting for
my patches to be included.
