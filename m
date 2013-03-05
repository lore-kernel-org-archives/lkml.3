Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026Ab3CEUhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:37:40 -0500
Received: from sema.semaphore.gr ([78.46.194.137]:53438 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753867Ab3CEUhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:37:39 -0500
Message-ID: <5136578D.3040908@semaphore.gr>
Date: Tue, 05 Mar 2013 22:37:33 +0200
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: David C Niemi <dniemi@verisign.com>
CC: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next] cpufreq: conservative: Fix sampling_down_factor
 functionality
References: <51351CC3.4010301@semaphore.gr> <CAOh2x=m0KLbjGKvLvTH7-yQb4SU5-v=-r4Ba3LSZz=NvfvO6mg@mail.gmail.com> <51358117.9060902@semaphore.gr> <5135FD01.8060306@verisign.com> <5135FF50.4020001@verisign.com>
In-Reply-To: <5135FF50.4020001@verisign.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,
On 03/05/2013 04:21 PM, David C Niemi wrote:
>
> I should clarify -- I wrote the sampling_down_factor in the *ondemand* governor.  I chose the name of the parameter based on the vaguely similar parameter in the conservative governor, but the documentation that was referenced (about it only applying at top speed and the comment about skipping evaluation opportunities when it is active) was written by me in reference to the ondemand governor.  It could be that someone backported some of the ondemand sampling_down_factor's behavior to the conservative governor.
>
> I'd like to ask -- what is the intended use of the conservative governor these days as differentiated from the ondemand governor?  At one time it seemed more oriented towards power savings, but the ondemand governor had picked up most or all of its power-saving features.

Thanks for the information.
I would agree about the use of conservative, but I think that I'm not
the right person to answer this question. :)

Regards,
Stratos
