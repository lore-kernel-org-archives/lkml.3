Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbaCJRl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:41:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:52228 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbaCJRlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:41:42 -0400
Message-ID: <531DF953.7050005@linutronix.de>
Date: Mon, 10 Mar 2014 18:41:39 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mike Galbraith <bitbucket@online.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>, tglx@linutronix.de
Subject: Re: [PATCH RT] fs: jbd2: pull your plug when waiting for space
References: <20140221123253.GA12822@linutronix.de> <20140310132602.6d4b0e53@gandalf.local.home>
In-Reply-To: <20140310132602.6d4b0e53@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2014 06:26 PM, Steven Rostedt wrote:
> I'm a little confused. Is this only needed for 3.12-rt? I see that you
> did not mark it for stable.

it supposed to go stable. Sorry about the missing tag.

> -- Steve

Sebastian
