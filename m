Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934304Ab3BSVEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 16:04:46 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63756 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933498Ab3BSVEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 16:04:45 -0500
Date: Tue, 19 Feb 2013 13:04:43 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mathias Krause <minipli@googlemail.com>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        PaX Team <pageexec@freemail.hu>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: apic: Fix parsing of lapic cmdline option
In-Reply-To: <1361303227-13174-1-git-send-email-minipli@googlemail.com>
Message-ID: <alpine.DEB.2.02.1302191304280.5220@chino.kir.corp.google.com>
References: <1361303227-13174-1-git-send-email-minipli@googlemail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2013, Mathias Krause wrote:

> Including " lapic " in the kernel cmdline on an x86-64 kernel makes it
> panic while parsing early params -- e.g. with no user visible output.
> 
> Fix this bug by ensuring arg is non-NULL before passing it to strncmp().
> 
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> Reported-by: PaX Team <pageexec@freemail.hu>
> Cc: stable@vger.kernel.org	# v3.8

Acked-by: David Rientjes <rientjes@google.com>
