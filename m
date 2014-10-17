Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbaJQNZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 09:25:33 -0400
Received: from mail-oi0-f48.google.com ([209.85.218.48]:57457 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbaJQNZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 09:25:31 -0400
MIME-Version: 1.0
In-Reply-To: <54410862.6020508@redhat.com>
References: <543BCF9A.1060603@redhat.com>
	<CAKohpo=KVJRdX1h=Pp2mo63QXh+5ygS9RQ=EUXaq8z+JBDFykQ@mail.gmail.com>
	<54410862.6020508@redhat.com>
Date: Fri, 17 Oct 2014 18:55:30 +0530
Message-ID: <CAKohpo=NH-eY__krHPgAUmrbxm-dd+rP9yGj3mGdXDxUQyPJVg@mail.gmail.com>
Subject: Re: Locking issues with cpufreq and sysfs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Robert_Sch=C3=B6ne?= <robert.schoene@tu-dresden.de>,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 October 2014 17:45, Prarit Bhargava <prarit@redhat.com> wrote:
> Hmmm
>
> This is what I'm doing:
>
> echo ondemand > scaling_governor
> cat ondemand/*
> echo conservative > scaling_governor
>
> OOC what are you doing to test?

Exactly same and even tried Roberts script too :)
