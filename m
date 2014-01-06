Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaAFKyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 05:54:12 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:57323 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbaAFKyK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 05:54:10 -0500
MIME-Version: 1.0
In-Reply-To: <87a9f92xnn.fsf@nemi.mork.no>
References: <f9d7b0d5424e4443597d2ed39bec3fedd2b10d1e.1387848958.git.viresh.kumar@linaro.org>
	<5562479.pVWRuDL0y6@vostro.rjw.lan>
	<87zjne7f75.fsf@nemi.mork.no>
	<2302938.b8tymqrMEz@vostro.rjw.lan>
	<878uuxquxu.fsf@nemi.mork.no>
	<871u0po0gx.fsf@nemi.mork.no>
	<CAKohpo=9p8ArfWyyWkdQm_BWtyWbWe_dsg6VAUP60VUFcAjFSw@mail.gmail.com>
	<87wqihmg9a.fsf@nemi.mork.no>
	<CAKohpo=3s6=gw8OJTrUdLH8o2ouA=8a8MhrgNRXwHmOf0si5Pw@mail.gmail.com>
	<87iotx32mx.fsf@nemi.mork.no>
	<CAKohpo=KgHqz0KYv7h0EYP3=8h7T3ZfPpFTMS6qVoEb6dXGnSQ@mail.gmail.com>
	<87a9f92xnn.fsf@nemi.mork.no>
Date: Mon, 6 Jan 2014 16:24:09 +0530
Message-ID: <CAKohpon7u_1h+9rKQeC8J4Pqd_6bSajn7Ag8=COqczhbSPEgMA@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: try to resume policies which failed on last resume
From: Viresh Kumar <viresh.kumar@linaro.org>
To: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 January 2014 16:19, Bjørn Mork <bjorn@mork.no> wrote:
> I cancelled by pressing backspace while the image was being written.

I will answer other queries on next mail, but a quick question:
Do you get these warnings even if you don't cancel hibernation?
