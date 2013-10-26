Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab3JZVe7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 17:34:59 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:38910 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab3JZVe6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 17:34:58 -0400
References: <5266bc543597964da@agluck-desk.sc.intel.com> <52680aa01445165d7@agluck-desk.sc.intel.com> <CA+8MBbL8eO=4EGLwRhdLVDndRqX=uHJz3-EKzT=PJ-Bv0a-K2w@mail.gmail.com> <20131026101055.GB14949@gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20131026101055.GB14949@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <75C2D580-105E-4B49-80D4-E047C1530FC2@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        X86-ML <x86@kernel.org>
X-Mailer: iPhone Mail (11B511)
From: Tony Luck <tony.luck@gmail.com>
Subject: Re: [GIT PULLv2] For x86/mce ... enhanced error logs
Date: Sat, 26 Oct 2013 14:34:52 -0700
To: Ingo Molnar <mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hm, I'm not sure we should move something named after a hardware 
> feature into lib/. It's not really generic C library functionality, 
> 
Not a hardware feature. CPER stands for Common Platform Error Record from the UEFI standard. So applicable to three? architectures.

As Chen Gong points out, drivers/acpi isn't the right place ... so if not lib/ ... then where?

-Tony