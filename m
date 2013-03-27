Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab3C0Khw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 06:37:52 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:38099 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab3C0Khu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 06:37:50 -0400
MIME-Version: 1.0
In-Reply-To: <5152CADA.4020502@ti.com>
References: <cover.1364205812.git.viresh.kumar@linaro.org>
	<ef225dbf63b1d834761773384d3f70cb4ac7b611.1364205812.git.viresh.kumar@linaro.org>
	<5152C755.7010404@ti.com>
	<CAKohponaNZRdYETsb8W3trk8V7LeC7jsR49hJwGv1iYiVJcduw@mail.gmail.com>
	<5152CADA.4020502@ti.com>
Date: Wed, 27 Mar 2013 16:07:50 +0530
Message-ID: <CAKohpom9KLu0L_Ehkmd7sVd6KnhH0AsOV0jHF+CCZhwBLs671Q@mail.gmail.com>
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

On 27 March 2013 16:02, Sekhar Nori <nsekhar@ti.com> wrote:
> Too bad. But something needs to be done about it since we all like to
> apply patches received in email ;). I have seen reports of people
> configuring gmail to know their @company.com address as another e-mail
> address they own and then using gmail SMTP to send patches (git config).
> You should try that.

I don't use ARM's email id for sending mails and linaro id uses gmail servers
only for sending mails..

The problem is, when i am in office, i can' use google servers to send mails
and whatever mail i send from within ARM, they are broken.

I can use linaro servers from outside office without any issues and it is never
broken.

>> And for this reason only i push my patches in my public repo all the
>> time, mentioned in cover-letter.
>>
>> http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/cpufreq-move-drivers
>
> Okay but you never copied me on the cover letter so I only saw this one
> patch. I will pull your tree and test now.

This series was affecting lots of people and so every patch had a number of
people added as cc. I didn't wanted to add everybody in cc of complete
patchset.

BUT, i have another idea now. The way i used to add people in cc for specific
patches (by editing the patch), i will do the same for cover-letter
too next time.

And so all people will receive relevant patches + cover letter.

--
viresh
