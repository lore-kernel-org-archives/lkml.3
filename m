Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab3CFGns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 01:43:48 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:63789 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3CFGnq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 01:43:46 -0500
MIME-Version: 1.0
In-Reply-To: <5135FF50.4020001@verisign.com>
References: <51351CC3.4010301@semaphore.gr>
	<CAOh2x=m0KLbjGKvLvTH7-yQb4SU5-v=-r4Ba3LSZz=NvfvO6mg@mail.gmail.com>
	<51358117.9060902@semaphore.gr>
	<5135FD01.8060306@verisign.com>
	<5135FF50.4020001@verisign.com>
Date: Wed, 6 Mar 2013 14:43:45 +0800
Message-ID: <CAKohpo=LVj+1RSFSmKk1WUYZJDY_rNSYd8H=B1sBK3NObgd=wg@mail.gmail.com>
Subject: Re: [PATCH linux-next] cpufreq: conservative: Fix sampling_down_factor
 functionality
From: Viresh Kumar <viresh.kumar@linaro.org>
To: David C Niemi <dniemi@verisign.com>
Cc: Stratos Karafotis <stratosk@semaphore.gr>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 March 2013 22:21, David C Niemi <dniemi@verisign.com> wrote:
> I'd like to ask -- what is the intended use of the conservative governor these days as differentiated from the ondemand governor?  At one time it seemed more oriented towards power savings, but the ondemand governor had picked up most or all of its power-saving features.

I believe the difference is still the same.. conservative is not as
aggressive as
ondemand now also, i don't know which people are using it though :)
