Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaEVIXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 04:23:55 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:35623 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbaEVIXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 04:23:42 -0400
MIME-Version: 1.0
In-Reply-To: <1400740894.21254.8.camel@x220>
References: <1400702036.30334.6.camel@x220>
	<CAK9yfHz2kdfkf+o7fKMRu=nMXxbcHJ227bjpvA=WXt6ptH3QRA@mail.gmail.com>
	<1400740894.21254.8.camel@x220>
Date: Thu, 22 May 2014 13:53:41 +0530
Message-ID: <CAK9yfHzf-Z3AQ4+-sF7xqqUw4dN8aULkCNvLQnmusp_ZiOg+Rw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: s5pv210: remove unused call of pr_err()
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 22 May 2014 12:11, Paul Bolle <pebolle@tiscali.nl> wrote:
> Sachin,
>
> On Thu, 2014-05-22 at 08:52 +0530, Sachin Kamat wrote:
>> The config symbol itself is not defined and hence could be removed.
>> However I feel, the
>> error message could be retained after trimming down the arguments a bit.
>
> My reasoning is, of course, that never used code can simply be dropped.

Yes, I agree. However the error message in this case should have been outside
the ifdefs to begin with as it is not an extra information but an
essential message
reporting error condition.

>
> But you want to print an error here. That's fine with me. I prefer if
> you'd submit a patch that does that, as I have no idea whatsoever why an
> error is needed here nor what that error should say.

You may just remove the __FILE__ and __LINE__ thing and leave the message as is.

pr_err("Denied access to %s as it is disabled temporarily\n", __func__);

-- 
With warm regards,
Sachin
