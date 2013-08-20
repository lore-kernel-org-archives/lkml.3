Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab3HTHOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:14:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:53542 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab3HTHOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:14:22 -0400
Message-ID: <52131747.4010105@linutronix.de>
Date: Tue, 20 Aug 2013 09:14:15 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
        Kent Overstreet <kmo@daterainc.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.10.6-rt3
References: <20130812163413.GI23040@linutronix.de> <520D212F.7030400@localhost> <20130815152210.5ed93696@gandalf.local.home> <520DCE5F.1040402@linutronix.de> <521254A0.6050603@localhost> <20130819202903.692097ea@gandalf.local.home> <20130819210208.426e01b3@gandalf.local.home>
In-Reply-To: <20130819210208.426e01b3@gandalf.local.home>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 03:02 AM, Steven Rostedt wrote:
> Looking at it more, I can now see why they did what they did.

He is the only user in the whole kernel. It is somehow hard to believe
that it can't be solved differently.

> -- Steve

Sebastian
