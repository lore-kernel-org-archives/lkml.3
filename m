Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab3L0MYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 07:24:43 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55325 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab3L0MYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 07:24:41 -0500
Date: Fri, 27 Dec 2013 12:24:22 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: intel_pstate divide error with v3.13-rc4-256-gb7000ad
Message-ID: <20131227122422.62857cec@alan.etchedpixels.co.uk>
In-Reply-To: <CAKohpomqHApogDEXA5LyWk-+B-Y1mwNQ63-wL3PPGz64s_3Dmw@mail.gmail.com>
References: <CA+5PVA6YpKc6kYK5UiTnGLZpB8uts=-QPtyhotAyZ2kuoG8PPQ@mail.gmail.com>
	<CAKohpomqHApogDEXA5LyWk-+B-Y1mwNQ63-wL3PPGz64s_3Dmw@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Dec 2013 21:36:01 +0530
Viresh Kumar <viresh.kumar@linaro.org> wrote:

> Adding Dirk..
> 
> On 24 December 2013 20:06, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> > Hi All,
> >
> > We've had a report [1] that the pstate driver causes KVM guests to
> > fail to boot because of a divide error.  See the backtrace below.
> >
> >     4.839784] Intel P-state driver initializing.
> > [    4.859972] Intel pstate controlling: cpu 0
> > [    4.867653] cpufreq: __cpufreq_add_dev: ->get() failed
> 
> After a call to ->init(), ->get() is supposed to work.
> @Dirk: Any idea why it failed?
> 
> And then I don't know what made this divide by zero to happen :)

> > [    4.878127] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011

Emulator bug perhaps ?

