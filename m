Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbbAMLWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:22:30 -0500
Received: from www.linutronix.de ([62.245.132.108]:44100 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbbAMLW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:22:29 -0500
Date: Tue, 13 Jan 2015 12:22:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexander Kuleshov <kuleshovmail@gmail.com>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86/boot: Add ability to call printf in video modes
 initialization
In-Reply-To: <1420638894-14286-1-git-send-email-kuleshovmail@gmail.com>
Message-ID: <alpine.DEB.2.11.1501131221130.5526@nanos>
References: <1420638894-14286-1-git-send-email-kuleshovmail@gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2015, Alexander Kuleshov wrote:

> Added ability to call printf in video-mode.c, video-bios.c, video-vesa.c and
> video-vga.c for debugging purposes.

And what's the exact purpose of this change? Increase binary size for
nothing?

Thanks,

	tglx
