Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbaE0Wzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 18:55:54 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60000 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752108AbaE0Wzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 18:55:53 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mark Brown <broonie@kernel.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linaro-kernel@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        arvind.chauhan@arm.com, edubezval@gmail.com, pavel@ucw.cz,
        lgirdwood@gmail.com
Subject: Re: [PATCH 1/2] regulators: Add definition of regulator_set_voltage_time() for !CONFIG_REGULATOR
Date: Wed, 28 May 2014 01:12:57 +0200
Message-ID: <233568355.QJI3TVGr1I@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140527192923.GC12304@sirena.org.uk>
References: <1780c3205893be8567fa29ccd86674e2f32555b4.1401192160.git.viresh.kumar@linaro.org> <20140527192923.GC12304@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 27, 2014 08:29:23 PM Mark Brown wrote:
> 
> --wJgPvdDu+gj56kJ8
> Content-Type: text/plain; charset=us-ascii
> Content-Disposition: inline
> 
> On Tue, May 27, 2014 at 05:37:29PM +0530, Viresh Kumar wrote:
> 
> > Liam/Broonie: Please see if this can go through Rafael as 2nd patch is dependent
> > on it.
> 
> Is that likely to happen before the merge window?

Depending.  If there's -rc8, then maybe.  Otherwise, nope.

Rafael

