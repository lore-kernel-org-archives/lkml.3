Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaEZX7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 19:59:37 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:34866 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbaEZX7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 19:59:35 -0400
MIME-Version: 1.0
In-Reply-To: <2164172.cubRkjSW1o@vostro.rjw.lan>
References: <cover.1400662383.git.viresh.kumar@linaro.org>
	<b2ed4e111222c2367a77a1382a6a7ea232ef9b59.1400662383.git.viresh.kumar@linaro.org>
	<2164172.cubRkjSW1o@vostro.rjw.lan>
Date: Tue, 27 May 2014 05:29:34 +0530
Message-ID: <CAKohpo=F2yYc8r=oA6Y43c-FAgPBeAz8sRnYjbS0K8HE0OmpRg@mail.gmail.com>
Subject: Re: [PATCH V4 1/3] cpufreq: handle calls to ->target_index() in
 separate routine
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Doug Anderson <dianders@chromium.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 May 2014 04:51, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> I guess I can take this one without the rest of the series?

Yes.
