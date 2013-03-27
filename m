Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab3C0KVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 06:21:35 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:58332 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3C0KVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 06:21:33 -0400
MIME-Version: 1.0
In-Reply-To: <5152C755.7010404@ti.com>
References: <cover.1364205812.git.viresh.kumar@linaro.org>
	<ef225dbf63b1d834761773384d3f70cb4ac7b611.1364205812.git.viresh.kumar@linaro.org>
	<5152C755.7010404@ti.com>
Date: Wed, 27 Mar 2013 15:51:32 +0530
Message-ID: <CAKohponaNZRdYETsb8W3trk8V7LeC7jsR49hJwGv1iYiVJcduw@mail.gmail.com>
Subject: Re: [PATCH 3/9] cpufreq: davinci: move cpufreq driver to drivers/cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Sekhar Nori <nsekhar@ti.com>
Cc: rjw@sisk.pl, arvind.chauhan@arm.com, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, arnd.bergmann@linaro.org,
        linux@arm.linux.org.uk, davinci-linux-open-source@linux.davincidsp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 March 2013 15:47, Sekhar Nori <nsekhar@ti.com> wrote:
> On 3/25/2013 3:41 PM, Viresh Kumar wrote:
> I am unable to apply this patch for testing. Looks like this could be
> because of:
>
> Content-Type: text/plain; charset="WINDOWS-1252"
>
> Can you get rid of that charset="WINDOWS-1252"?

I can't, its MSF exchange server behind this.

And for this reason only i push my patches in my public repo all the
time, mentioned in cover-letter.

http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/cpufreq-move-drivers
