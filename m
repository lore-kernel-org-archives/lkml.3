Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbaDQTZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 15:25:24 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:52751 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaDQTZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 15:25:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140417192330.GE4321@pd.tnic>
References: <tip-ea431643d6c38728195e2c456801c3ef66bb9991@git.kernel.org>
	<20140417100944.GG11096@twins.programming.kicks-ass.net>
	<20140417102442.GA8215@pd.tnic>
	<3908561D78D1C84285E8C5FCA982C28F31E2A1D3@ORSMSX106.amr.corp.intel.com>
	<20140417152611.GD4321@pd.tnic>
	<CA+5PVA7i=RrGUk_7zz1yU5gseWpvr+a=4dfkg=n9cNc53S7nPA@mail.gmail.com>
	<20140417192330.GE4321@pd.tnic>
Date: Thu, 17 Apr 2014 12:25:14 -0700
X-Google-Sender-Auth: C7iweHgzfqJfQwBzIEWZKp7ff64
Message-ID: <CA+55aFyz62W7CD9=9p9OxKuFs9Rck_p93E_40CqLat1HvDdf0Q@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86/mce: Fix CMCI preemption bugs
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Owen Kibel <qmewlo@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "atodorov@redhat.com" <atodorov@redhat.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 12:23 PM, Borislav Petkov <bp@alien8.de> wrote:
>
> But you're saying here, Owen tested it already.

No, Owen tested a simpler patch that just changes the "get_cpu_var()"
to "__get_cpu_var()" and avoids the preempt increment.

              Linus
