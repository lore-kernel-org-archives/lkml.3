Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759752AbaKATlg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 15:41:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:47378 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758252AbaKATle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 15:41:34 -0400
Date: Sat, 1 Nov 2014 20:41:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Guenter Roeck <linux@roeck-us.net>
cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH v3 30/47] x86: iris: Register with kernel power-off
 handler
In-Reply-To: <1414425354-10359-31-git-send-email-linux@roeck-us.net>
Message-ID: <alpine.DEB.2.11.1411012040510.5308@nanos>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net> <1414425354-10359-31-git-send-email-linux@roeck-us.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, Guenter Roeck wrote:

> Register with kernel power-off handler instead of setting pm_power_off
> directly. Register with high priority to reflect that the original code
> overwrites existing power-off handlers.

Acked-by-me for all the x86 parts of that series.

Thanks,

	tglx

