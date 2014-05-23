Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaEWN2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 09:28:17 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:48756 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbaEWN2O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 09:28:14 -0400
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH V3 1/8] cpufreq: cpufreq-cpu0: remove dependency on thermal
From: Viresh Kumar <viresh.kumar@linaro.org>
X-Mailer: iPad Mail (11D201)
In-Reply-To: <20140523132144.GA3138@developer>
Date: Fri, 23 May 2014 18:58:24 +0530
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Ips Gandhi <inderpal.s@samsung.com>, Nishanth Menon <nm@ti.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, "Brown, Len" <len.brown@intel.com>,
        Sudeep Holla <sudeep.holla@arm.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <711BA092-F65D-4D62-9D94-E246387065A4@linaro.org>
References: <cover.1400736536.git.viresh.kumar@linaro.org> <c73c825beda0207867bd29e40fece217cbf15925.1400736536.git.viresh.kumar@linaro.org> <20140522145209.GA5246@developer> <CAKohpo=e62HPRF0N7kDvZEBAVPMFUeXVoL4jU--i7bZhn6Kjgw@mail.gmail.com> <20140523132144.GA3138@developer>
To: Eduardo Valentin <edubezval@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On 23-May-2014, at 6:51 pm, Eduardo Valentin <edubezval@gmail.com> wrote:
> I agree. We need to have runtime dependency, and that is the major
> concern on my behalf. The problem of Kconfig dependency is that it
> imposes sequencing only on module loading, not at boot sequencing.
> 
> Another way around is returning -EPROBE_DEFER when some API is not ready at device probing for instance.

Okay, coming back to this patch. This driver is usable without thermal.
And so the dependencies better be dropped ?