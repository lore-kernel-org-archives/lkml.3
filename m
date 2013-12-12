Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab3LLBMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 20:12:24 -0500
Received: from alt-proxy11.mail.unifiedlayer.com ([74.220.211.241]:33716 "HELO
	alt-proxy11.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751155Ab3LLBMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 20:12:21 -0500
Date: Wed, 11 Dec 2013 17:14:07 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: Resume regression in 5a87182aa21d6d5d306840feab9321818dd3e2a3
Message-ID: <20131211171407.1b1b01b2@jbarnes-desktop>
In-Reply-To: <1905118.1iBkDjFnLH@vostro.rjw.lan>
References: <20131211163812.297d4c81@jbarnes-desktop>
	<1905118.1iBkDjFnLH@vostro.rjw.lan>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Dec 2013 02:22:52 +0100
"Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:

> On Wednesday, December 11, 2013 04:38:12 PM Jesse Barnes wrote:
> > On one of my BYT systems, I see a hang at resume.  Based on my bisect,
> > it looks like this commit is the culprit:
> > 
> > commit 5a87182aa21d6d5d306840feab9321818dd3e2a3
> > Author: Viresh Kumar <viresh.kumar@linaro.org>
> > Date:   Wed Nov 27 09:09:42 2013 +0530
> > 
> >     cpufreq: suspend governors on system suspend/hibernate
> > 
> > Is this a known issue?
> 
> Yes.
> 
> > If so, is there a fix somewhere already?
> 
> The commit has been reverted (in the Linus' tree).

Great, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
