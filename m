Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab3JJXEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 19:04:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48066 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab3JJXEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 19:04:42 -0400
Message-ID: <52573279.9020404@zytor.com>
Date: Thu, 10 Oct 2013 16:04:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RFD: Does CONFIG_X86_LOCAL_APIC still make sense?
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to wrap my head around if there are use cases where disabling
either CONFIG_X86_UP_APIC or CONFIG_X86_LOCAL_APIC would ever make sense
anymore.

I am guessing there are probably some small number of embedded systems
which still don't have LAPICs, but is it a significant number and does
anyone care for new kernels?  We are not talking about discontinuing
support for non-APIC configurations, just the configuration option.

	-hpa
