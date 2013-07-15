Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab3GOXPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 19:15:24 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43976 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126Ab3GOXPX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 19:15:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        viresh.kumar@linaro.org, robert.jarzmik@intel.com,
        durgadoss.r@intel.com, tianyu.lan@intel.com, lantianyu1986@gmail.com,
        dirk.brandewie@gmail.com, stern@rowland.harvard.edu,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Cpufreq, cpu hotplug, suspend/resume related fixes
Date: Tue, 16 Jul 2013 01:25:13 +0200
Message-ID: <2233063.0GCWqjjfbB@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51E4337A.7020509@gmx.de>
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com> <6515593.XAmN11qlGF@vostro.rjw.lan> <51E4337A.7020509@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 15, 2013 07:38:02 PM Toralf Förster wrote:
> On 07/12/2013 12:33 AM, Rafael J. Wysocki wrote:
> > I'm going to take [1/8] for 3.11 and queue up the rest for 3.12 if people don't
> > hate them.  This way we'll have some more testing coverage before they reach
> > the mainline hopefully.
> 
> Applied patch 1#8 on top of v3.11-rc1-8-g47188d3 passes two s2ram/wakeup

Sorry, I have no idea what 1#8 means.

> cycles fine and crashed the system at the 3rd attempt / one times just
> at the 4th (blinking power led, no sysrq, ...).
> 
> Applying patch 1-8 on top of that tree differs in that way that it
> crashes now the system even at the 1st attempt or at least at the 2nd

What are you talking about?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
