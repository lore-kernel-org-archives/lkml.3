Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172AbaDHEWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 00:22:47 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:50810 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaDHEWn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 00:22:43 -0400
MIME-Version: 1.0
In-Reply-To: <5b6a0eb5-59d7-43ca-9adc-35c7acd58424@VA3EHSMHS022.ehs.local>
References: <324f43fc664f51eec355b08b6c2d4cedd2140b4c.1392628861.git.viresh.kumar@linaro.org>
	<1848612.IZFZXgfmHj@vostro.rjw.lan>
	<5b6a0eb5-59d7-43ca-9adc-35c7acd58424@VA3EHSMHS022.ehs.local>
Date: Tue, 8 Apr 2014 09:52:43 +0530
Message-ID: <CAKohpom_Lk+YdeKvEh-rbX-rsARZO3tHxzMD8PDQ6kycaA+D9A@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: remove sysfs link when a cpu != policy->cpu, is removed
From: Viresh Kumar <viresh.kumar@linaro.org>
To: =?ISO-8859-1?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 April 2014 22:45, Sören Brinkmann <soren.brinkmann@xilinx.com> wrote:
> I see this on 3.13 too (in our vendor tree, but I think mainline would
> show the behavior as well). It probably worth to add it into the 3.13
> stable kernel.

Thanks.. Patch sent for stable tree.
