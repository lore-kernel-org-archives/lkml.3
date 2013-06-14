Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab3FNOtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 10:49:40 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:37447 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab3FNOti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 10:49:38 -0400
MIME-Version: 1.0
In-Reply-To: <8166789.M9n1Uisvhs@vostro.rjw.lan>
References: <1370419882-16831-1-git-send-email-cw00.choi@samsung.com>
	<51BA7BDB.9070801@samsung.com>
	<CAKohpokL1PNsYXJvnrkYesUHhe4s9-HsZe_c5KW+toeHJep2PA@mail.gmail.com>
	<8166789.M9n1Uisvhs@vostro.rjw.lan>
Date: Fri, 14 Jun 2013 20:19:38 +0530
Message-ID: <CAKohpo=TNf=XK7S6_8Z92XvpBz-7jOqYA=p61c9qG3GSg7tzfA@mail.gmail.com>
Subject: Re: [RESEND][PATCH] cpufreq: stats: Add 'load_table' sysfs file to
 show accumulated data of CPU
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 June 2013 18:18, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, June 14, 2013 09:41:13 AM Viresh Kumar wrote:
>> @Rafael: Would it be move trans_table to debugfs??

Oops!! What stupid english.

s/be/be sensible to/

> I'm not sure who uses it now.  If there are any user space tools depending on
> it in use, I'm afraid we can't just move it around.

Even I am also unsure about it.
