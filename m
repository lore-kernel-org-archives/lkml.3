Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab3CaDry (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 23:47:54 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:59783 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174Ab3CaDrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 23:47:52 -0400
MIME-Version: 1.0
In-Reply-To: <4183493.GBcPoVddxx@vostro.rjw.lan>
References: <cover.1364398686.git.viresh.kumar@linaro.org>
	<1656173.qmCdUDP7Pu@vostro.rjw.lan>
	<CAKohponaAyo2BL3X+rxNTO9-u88dfj7Vho6zRyUmvct6XyHyVw@mail.gmail.com>
	<4183493.GBcPoVddxx@vostro.rjw.lan>
Date: Sun, 31 Mar 2013 09:17:52 +0530
Message-ID: <CAKohpo=AKcuJBxv+6aDOoZ9QYjPj4SqckFPaf-P06hvsCDZ=ig@mail.gmail.com>
Subject: Re: [PATCH V4 0/2] Implement per policy instance of governor
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, arvind.chauhan@arm.com, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, jacob.shin@amd.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 March 2013 07:19, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Yes, thanks.
>
> But the patches moving cpufreq drivers into drivers/cpufreq from somewhere else
> need each an ACK from the maintainer of that other place.  I won't take any
> patches like that without AKCs.

Okay. I will ask respective maintainers (Who haven't acked until now)
to provide one.
