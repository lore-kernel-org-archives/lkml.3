Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab3BEO6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:58:41 -0500
Received: from relay2.sgi.com ([192.48.179.30]:38270 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755155Ab3BEO6h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:58:37 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
Subject: RE: [PATCH 0/2] cpufreq: cpufreq_driver_lock is hot on large systems
Thread-Topic: [PATCH 0/2] cpufreq: cpufreq_driver_lock is hot on large
 systems
Thread-Index: AQHOAzxEixsA/U4uA0Wy4a3AfPE0fJhrU54AgAAag4D///6uAIAABCKA///qEQc=
Date: Tue, 5 Feb 2013 14:58:35 +0000
Message-ID: <74F10842A85F514CA8D8C487E74474BB2D2F925E@P-EXMB1-DC21.corp.sgi.com>
References: <1360017913-25667-1-git-send-email-nzimmer@sgi.com>
 <3480441.gCEh0J5edK@vostro.rjw.lan>
 <CAOh2x=mWc9rBX3O_1NSr23TAWFtRA6BNW3TZ8FhZOMdH_0dmzQ@mail.gmail.com>,<1535355.NvOsIhbBYp@vostro.rjw.lan>
In-Reply-To: <1535355.NvOsIhbBYp@vostro.rjw.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.149.23.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I'll rebase and retest from linux-next then.


________________________________________
From: Rafael J. Wysocki [rjw@sisk.pl]
Sent: Tuesday, February 05, 2013 4:13 AM
To: Viresh Kumar
Cc: Nathan Zimmer; linux-kernel@vger.kernel.org; linux-pm@vger.kernel.org; cpufreq@vger.kernel.org; Shawn Guo; linaro-dev@lists.linaro.org
Subject: Re: [PATCH 0/2] cpufreq: cpufreq_driver_lock is hot on large systems

On Tuesday, February 05, 2013 03:28:30 PM Viresh Kumar wrote:
> On Tue, Feb 5, 2013 at 3:33 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > I actually don't agree with that, becuase the Nathan's apprach shows the
> > reasoning that leads to the RCU introduction quite clearly.  So if you
> > don't have technical problems with the patchset, I'm going to take it as is.
>
> Great!!
>
> Okay.. I don't have any technical problems with it, i reviewed most of it
> carefully. The only pending thing is rebase on linux-next, after that i can
> give my ack for it.

Yes, it would be great if it were rebased and retested.

Thanks,
Rafael


--
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.