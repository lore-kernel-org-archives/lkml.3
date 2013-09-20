Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab3ITTaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 15:30:22 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:51875 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab3ITTaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 15:30:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWm=Db4e8nYdVJzpirmV2EfKxEYYRHo6ggTtX0CY3-hhg@mail.gmail.com>
References: <1379563520-7221-1-git-send-email-yinghai@kernel.org>
	<CAKohpom-3orEns00DC2=uk4pgV_xnfRpM1hrdyK9pjPUEgBXrA@mail.gmail.com>
	<CAE9FiQU5PD4asdE3=sBSnLK8fwPT8vK81FAOuYtAWj_3ruyS0g@mail.gmail.com>
	<3290463.fBbGMovmdx@vostro.rjw.lan>
	<CAE9FiQWm=Db4e8nYdVJzpirmV2EfKxEYYRHo6ggTtX0CY3-hhg@mail.gmail.com>
Date: Fri, 20 Sep 2013 12:30:19 -0700
X-Google-Sender-Auth: B_00lPfwuU9uo16q7piJkjYZ3to
Message-ID: <CAE9FiQUDwkQOt+rO8vbJW6hv3swP1n5kP3dT_rESoWUj5G6ANw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: return EEXIST instead of EBUSY for second registering
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 10:12 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>>
>> I *think* we can just drop the module requesting stuff entirely, because it
>> doesn't seem to work anyway and udev is handling this for us.
>
Yes. looks like acpi_processor_load_module() is not needed.
udev will do the work.
