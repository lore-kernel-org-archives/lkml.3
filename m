Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab3BFKQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:16:05 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:51052 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab3BFKQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:16:02 -0500
MIME-Version: 1.0
In-Reply-To: <CAP245DUMnSMSoXo2JoMu1CgNROQ2YT7kd7e9svWoZ_EG2QLi+Q@mail.gmail.com>
References: <cover.1359976493.git.viresh.kumar@linaro.org>
	<CAKohpomK1jZMy=mQJFysbdeXZAuzWJ3gcStA+imYHouGfmcgLw@mail.gmail.com>
	<CAKohpokFCAqdoeBoMJ3Jzh05x8wUg4kfo+XirxUjw=2_4_0wJA@mail.gmail.com>
	<CAP245DUMnSMSoXo2JoMu1CgNROQ2YT7kd7e9svWoZ_EG2QLi+Q@mail.gmail.com>
Date: Wed, 6 Feb 2013 15:45:58 +0530
Message-ID: <CAKohpo=T+YJxkxyWJQ_SdsFHcY_Xv-SXy_mZNLe7a3CtDF-7gw@mail.gmail.com>
Subject: Re: [PATCH 0/4] CPUFreq: Implement per policy instances of governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Amit Kucheria <amit.kucheria@linaro.org>
Cc: rjw@sisk.pl, Borislav Petkov <bp@alien8.de>,
        Steve Bannister <Steve.Bannister@arm.com>,
        Lists linaro-dev <linaro-dev@lists.linaro.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 February 2013 15:38, Amit Kucheria <amit.kucheria@linaro.org> wrote:
> On Wed, Feb 6, 2013 at 3:28 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> I have pushed the complete patchset here:
>>
>> http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/cpufreq-updates
>>
>
> Viresh, perhaps you should ask Stephen Rothwell to pull in your tree
> to get some more testing before Rafael pulls it in for 3.10?

Its has been made clear by Rafael that these patches wouldn't make it for
3.9 (though i wanted them to :) ), and so once the merge window is over
Rafael might pull them in and so they would reach Stephen's linux-next too...

I am not sure if sending a cpufreq pull request directly to Stephen is
preferred.
@Rafael: ??
