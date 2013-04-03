Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761958Ab3DCDR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 23:17:27 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34838 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761478Ab3DCDR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 23:17:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAAQ0ZWQrrGhhwEMg_0ifMLZdgB4u6d7c4QqyejgRphRx5Mft6A@mail.gmail.com>
References: <1364920232-9604-1-git-send-email-fabio.estevam@freescale.com>
	<20130403022939.GL24039@S2101-09.ap.freescale.net>
	<CAAQ0ZWQrrGhhwEMg_0ifMLZdgB4u6d7c4QqyejgRphRx5Mft6A@mail.gmail.com>
Date: Wed, 3 Apr 2013 00:17:25 -0300
Message-ID: <CAOMZO5CdXcCFh77q+BMJhjw8xZ5W0bnE0gXK+H-h4_AYT8kpiA@mail.gmail.com>
Subject: Re: [PATCH] clocksource: mxs_timer: Add semicolon at end of line
From: Fabio Estevam <festevam@gmail.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 2, 2013 at 11:56 PM, Shawn Guo <shawn.guo@linaro.org> wrote:

> Ok, I'm seeing the error now on linux-next. It's not about compiler
> but the commit 3d5a965 (clocksource: make CLOCKSOURCE_OF_DECLARE type
> safe), which removes the semicolon at end of the
> CLOCKSOURCE_OF_DECLARE definition.

Right, the removal of the semicolon at the end of
CLOCKSOURCE_OF_DECLARE definition is intentional in commit 3d5a965.
