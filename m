Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008AbbA2KIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:08:09 -0500
Received: from mail-yk0-f176.google.com ([209.85.160.176]:47913 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbbA2KIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:08:07 -0500
MIME-Version: 1.0
In-Reply-To: <20150129074411.GA4817@gmail.com>
References: <1422470186-7860-1-git-send-email-pure.logic@nexus-software.ie>
	<1422470186-7860-2-git-send-email-pure.logic@nexus-software.ie>
	<20150129074411.GA4817@gmail.com>
Date: Thu, 29 Jan 2015 12:08:06 +0200
Message-ID: <CAHp75Vfff-C++LWyyK+FWLnot=jO4kQvbDaN9hJ2_VrhG8n2Qg@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "dvhart@infradead.org" <dvhart@infradead.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2015 at 9:44 AM, Ingo Molnar <mingo@kernel.org> wrote:
> * Bryan O'Donoghue <pure.logic@nexus-software.ie> wrote:

[]

> In any case, I don't see any major problems with this code, so if
> it's fixed it could go into v3.20.

Brian, it would be really nice to have it in 3.20 since we have
several drivers already in upstream or be ready for 3.20.
It would be then first upstream kernel with minimal Quark support.

-- 
With Best Regards,
Andy Shevchenko
