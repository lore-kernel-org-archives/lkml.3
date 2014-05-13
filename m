Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaEMDBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 23:01:47 -0400
Received: from ns.horizon.com ([71.41.210.147]:14331 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750892AbaEMDBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 23:01:46 -0400
Date: 12 May 2014 23:01:44 -0400
Message-ID: <20140513030144.32557.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: john.stultz@linaro.org, linux@horizon.com
Subject: Re: [PATCH] ntp: make is_error_status() use its argument
Cc: lasaine@lvk.cs.msu.su, linux-kernel@vger.kernel.org
In-Reply-To: <53710AD5.504@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> CONFIG_NTP_PPS not CONFIG_SMP, right?

D'oh, yes.  I just noticed that there were two versions and one was
broken.  Somehow my search for the enclosing #ifdef was completely broken.
(I could swear I saw CONFIG_SMP, but looking now it's not even mentioned
in the file; maybe I switched editor windows?)

> Adding Alexander since he submitted the pps logic.

Thank you; some of these issues of code provenance and "who the heck do
I notify about this?" are a bit laborious to infer even with the help
of the git logs.
