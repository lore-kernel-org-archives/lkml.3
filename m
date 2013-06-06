Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064Ab3FFMKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:10:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932700Ab3FFMKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:10:30 -0400
Date: Thu, 6 Jun 2013 14:10:12 +0200
From: Borislav Petkov <bp@suse.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Stratos Karafotis <stratosk@semaphore.gr>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of
 target frequency
Message-ID: <20130606121012.GD21181@pd.tnic>
References: <51AF60D5.3080605@semaphore.gr>
 <20130605161703.GA29958@pd.tnic>
 <51AF71B6.6030408@semaphore.gr>
 <105446113.ZumbZWCbSi@vostro.rjw.lan>
 <20130606100138.GC21181@pd.tnic>
 <CAKohpo=cwxvcicw4svcvyKJOzGD9j+gzTyg=4yYg4EsY89C3EQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKohpo=cwxvcicw4svcvyKJOzGD9j+gzTyg=4yYg4EsY89C3EQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 03:40:13PM +0530, Viresh Kumar wrote:
> his patch will give significant improvement both power & performance wise.

Yes, and I'd like to see the paperwork on that. Numbers, and on a couple
of platforms/vendors if possible, please.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
