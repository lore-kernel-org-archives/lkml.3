Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbaFPNxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:53:15 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:49802 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751478AbaFPNxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:53:13 -0400
Message-ID: <1402926791.16903.4.camel@x41>
Subject: Re: [GIT PULL] scheduler tree changes for v3.16
From: Paul Bolle <pebolle@tiscali.nl>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Date: Mon, 16 Jun 2014 15:53:11 +0200
In-Reply-To: <20140603120752.GA26873@gmail.com>
References: <20140603120752.GA26873@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jun 2014 13:53:11.0290 (UTC) FILETIME=[4FA6BDA0:01CF896A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

Ingo Molnar schreef op di 03-06-2014 om 14:07 [+0200]:
> Peter Zijlstra (12):
>       [...]
>       sched/idle, x86: Switch from TS_POLLING to TIF_POLLING_NRFLAG

This introduces this obviously correct warning (on 32 bit x86):
    arch/x86/kernel/apm_32.c: In function 'apm_do_idle':
    arch/x86/kernel/apm_32.c:844:6: warning: unused variable 'polling' [-Wunused-variable]
      int polling;
          ^

Is the trivial patch to remove 'polling' queued somewhere?


Paul Bolle

