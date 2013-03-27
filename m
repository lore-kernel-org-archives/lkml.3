Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab3C0K5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 06:57:23 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42999 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806Ab3C0K5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 06:57:22 -0400
Message-ID: <5152D07A.3000906@ti.com>
Date: Wed, 27 Mar 2013 16:26:58 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@sisk.pl>, <arvind.chauhan@arm.com>, <robin.randhawa@arm.com>,
        <Steve.Bannister@arm.com>, <Liviu.Dudau@arm.com>,
        <charles.garcia-tobin@arm.com>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linaro-kernel@lists.linaro.org>, <arnd.bergmann@linaro.org>,
        <linux@arm.linux.org.uk>,
        <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH 3/9] cpufreq: davinci: move cpufreq driver to drivers/cpufreq
References: <cover.1364205812.git.viresh.kumar@linaro.org> <ef225dbf63b1d834761773384d3f70cb4ac7b611.1364205812.git.viresh.kumar@linaro.org> <5152C755.7010404@ti.com> <CAKohponaNZRdYETsb8W3trk8V7LeC7jsR49hJwGv1iYiVJcduw@mail.gmail.com>
In-Reply-To: <CAKohponaNZRdYETsb8W3trk8V7LeC7jsR49hJwGv1iYiVJcduw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/27/2013 3:51 PM, Viresh Kumar wrote:
> On 27 March 2013 15:47, Sekhar Nori <nsekhar@ti.com> wrote:
>> On 3/25/2013 3:41 PM, Viresh Kumar wrote:
>> I am unable to apply this patch for testing. Looks like this could be
>> because of:
>>
>> Content-Type: text/plain; charset="WINDOWS-1252"
>>
>> Can you get rid of that charset="WINDOWS-1252"?
> 
> I can't, its MSF exchange server behind this.
> 
> And for this reason only i push my patches in my public repo all the
> time, mentioned in cover-letter.
> 
> http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/cpufreq-move-drivers

I pulled your branch and briefly tested it on da850 evm. It doesn't seem
to have broken anything. So you can add:

Acked-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar

