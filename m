Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab3FGLF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 07:05:26 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:52028 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab3FGLFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 07:05:24 -0400
MIME-Version: 1.0
In-Reply-To: <54837539.yBQlA0EhhC@vostro.rjw.lan>
References: <CAKohpokdrw1KZuCx6Y5E1JyK-Yq0T1fh0qP+bEaqgZjoK8JEEQ@mail.gmail.com>
	<54837539.yBQlA0EhhC@vostro.rjw.lan>
Date: Fri, 7 Jun 2013 16:35:24 +0530
Message-ID: <CAKohponx-dSdRVX77Fa8ePKhppvvE=dS=ofJT0_+3014b38ZOg@mail.gmail.com>
Subject: Re: [GIT PULL] CPUFreq: ARM Updates for v3.11
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lists linaro-dev <linaro-dev@lists.linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 June 2013 16:41, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, June 07, 2013 04:26:36 PM Viresh Kumar wrote:

>>       cpufreq: bit.LITTLE needs cpufreq table
>
> That should be big.LITTLE I suppose?

Yes. This is not the first time I face this issue where big is
written as bit. Even I named one of my external repo like this
earlier and after a long time some other careful viewer caught
it :)

Fixed my branch now with s/bit/big.

Thanks.
