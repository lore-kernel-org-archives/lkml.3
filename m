Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbaI0GOx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 02:14:53 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:54062 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaI0GOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 02:14:51 -0400
Message-ID: <1411798486.5097.46.camel@marge.simpson.net>
Subject: Re: BUG: sleeping function called from invalid context at
 drivers/cpufreq/cpufreq.c:370
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Date: Sat, 27 Sep 2014 08:14:46 +0200
In-Reply-To: <2457441.tHFXzSCneW@vostro.rjw.lan>
References: <20140924081845.572814794@infradead.org>
	 <1411712697.6005.7.camel@marge.simpson.net>
	 <1411718040.6005.18.camel@marge.simpson.net>
	 <2457441.tHFXzSCneW@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-09-27 at 00:44 +0200, Rafael J. Wysocki wrote:

> Shouldn't that be pcc-cpufreq.c rather?

Yeah, silly mouse copy/pasted the wrong gitk bits.

> Also moving the spin_lock(&pcc_lock) after the cpufreq_freq_transition_begin()
> should fix the problem too (like the below).  Have you tried that?

Have now.  Yup, works and is prettier.

-Mike

