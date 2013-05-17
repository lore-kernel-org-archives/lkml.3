Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab3EQJrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 05:47:15 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:12190 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab3EQJrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 05:47:13 -0400
Date: Fri, 17 May 2013 11:47:04 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: Robert Norris <robn@opera.com>, Daniel Kurtz <djkurtz@chromium.org>,
        linux-kernel@vger.kernel.org, Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: PROBLEM: modprobe hang at startup (3.8.x, 3.9.x, IBM x3550)
Message-ID: <20130517114704.442f1368@endymion.delvare>
In-Reply-To: <5195F6C9.5050200@fold.natur.cuni.cz>
References: <1368408152.29197.140661229821177.2C1CC406@webmail.messagingengine.com>
	<20130514231626.GA12961@pyro.melbourne.osa>
	<20130515112044.753bb7bb@endymion.delvare>
	<20130515112741.GA23766@pyro.melbourne.osa>
	<20130515214923.036dabdb@endymion.delvare>
	<20130516034455.GA19452@pyro.melbourne.osa>
	<20130517103622.5000d277@endymion.delvare>
	<5195F6C9.5050200@fold.natur.cuni.cz>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 May 2013 11:22:17 +0200, Martin Mokrejs wrote:
> Hi,
>   while you are chasing some problem with i2c_801 I would like to mention
> that I never got an answer on the thread https://lkml.org/lkml/2013/1/23/405
> about a kmemleak reported by kernel . Maybe this could give you a hint?
> If these do not overlap I would be anyways glad to receive an answer via
> the original thread I have started.
> Thank you,
> Martin

I have no clue what the problem is nor how to investigate it, and in
fact I strongly suspect that this is either a false positive or a
problem in lower layers - driver core, sysfs etc. so nothing I can help
with.

So until someone comes with an evidence that there is an actual memory
leak in the i2c-i801 driver itself I'm not going to pay any attention
to your report, sorry.

-- 
Jean Delvare
