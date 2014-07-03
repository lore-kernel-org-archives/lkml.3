Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341AbaGCPdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:33:37 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:55528 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaGCPdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:33:36 -0400
MIME-Version: 1.0
In-Reply-To: <53B5861E02000078000204D1@mail.emea.novell.com>
References: <53B5861E02000078000204D1@mail.emea.novell.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 3 Jul 2014 08:33:15 -0700
Message-ID: <CALCETrVR194i97dp42-=Sa+Pz0qdDUgxDVcF-Yuihp6OKPy60Q@mail.gmail.com>
Subject: Re: [PATCH] x86-64: fix vDSO build
To: Jan Beulich <JBeulich@suse.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2014 at 7:34 AM, Jan Beulich <JBeulich@suse.com> wrote:
> Certain ld versions (observed with 2.20.0) put an empty .rela.dyn
> section into shared object files, breaking the assumption on the number
> of sections to be copied to the final output. Simply discard any empty
> SHT_REL and SHT_RELA sections to address this.
>
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Cc: Andy Lutomirski <luto@amacapital.net>

Acked-by: Andy Lutomirski <luto@amacapital.net>

although I'm hoping to get rid of this section copying crap soon anyway.

--Andy
