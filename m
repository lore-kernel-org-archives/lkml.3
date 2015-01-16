Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbbAPHF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 02:05:59 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:50082 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbbAPHF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 02:05:58 -0500
MIME-Version: 1.0
In-Reply-To: <201501161410.qF6rUO8n%fengguang.wu@intel.com>
References: <201501161410.qF6rUO8n%fengguang.wu@intel.com>
Date: Fri, 16 Jan 2015 12:35:57 +0530
Message-ID: <CAKohpon55ycK+BeUK4KPFuiWbZb39S_4xc9G8fDtXwM4LuGHJw@mail.gmail.com>
Subject: Re: [vireshk:cpufreq/core/locking 57/60] drivers/cpufreq/cpufreq.c:512:5:
 sparse: symbol '__cpufreq_boost_supported' was not declared. Should it be static?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: kbuild-all@01.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 January 2015 at 12:25, kbuild test robot <fengguang.wu@intel.com> wrote:
> tree:   https://git.linaro.org/people/vireshk/linux cpufreq/core/locking
> head:   12d5339e685739289c2f629c943b8bfad4c64f1e
> commit: fbce49b78afdaeeaee3017cfbd968e44ddba8496 [57/60] cpufreq: Drop forward declaration of __cpufreq_boost_trigger_state()
> reproduce:
>   # apt-get install sparse
>   git checkout fbce49b78afdaeeaee3017cfbd968e44ddba8496
>   make ARCH=x86_64 allmodconfig
>   make C=1 CF=-D__CHECK_ENDIAN__
>
>
> sparse warnings: (new ones prefixed by >>)
>
>>> drivers/cpufreq/cpufreq.c:512:5: sparse: symbol '__cpufreq_boost_supported' was not declared. Should it be static?
>
> Please review and possibly fold the followup patch.

Fixed. Thanks.
