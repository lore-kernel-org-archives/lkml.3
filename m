Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbaCJEPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 00:15:20 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:49843 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaCJEPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 00:15:17 -0400
MIME-Version: 1.0
In-Reply-To: <1394424432.30791.11.camel@joe-AO722>
References: <1394127279-29871-1-git-send-email-soren.brinkmann@xilinx.com>
	<CAKohpo=E2PAD7XNm4y3tXv6-ArPCj+8RG-WsJLOfvJoZ7EkstQ@mail.gmail.com>
	<1394424432.30791.11.camel@joe-AO722>
Date: Mon, 10 Mar 2014 12:15:16 +0800
Message-ID: <CAKohpok+W6hQ-2ST3+yBq4dr6qcZy61Z6dS05u1Ex-MsJ8nLFw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Reformat printk() statement
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 March 2014 12:07, Joe Perches <joe@perches.com> wrote:
> On Mon, 2014-03-10 at 11:53 +0800, Viresh Kumar wrote:
>> On 7 March 2014 01:34, Soren Brinkmann <soren.brinkmann@xilinx.com> wrote:
>> > Reformat a printk statement to:
>> >  - use pr_warn
>> >  - bring the whole string into a single line in favor of being able to
>> >    grep for the message (ignoring the 80 char limit)
>> >
>> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> []
>> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> A more comprehensive patch would be to:
>
> Add missing newlines
> Coalesce format fragments
> Convert printks to pr_<level>
> Align arguments
> ---
>  drivers/cpufreq/cpufreq.c | 85 ++++++++++++++++++++++-------------------------
>  1 file changed, 40 insertions(+), 45 deletions(-)

Thanks..

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
