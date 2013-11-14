Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab3KNSoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 13:44:11 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54782 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab3KNSoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 13:44:05 -0500
MIME-Version: 1.0
In-Reply-To: <20131114180455.GA32212@anatevka.fc.hp.com>
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
	<d73ccce9-6a0d-4470-bda3-f0c6eb96b5e4@email.android.com>
	<20131113224503.GB25344@anatevka.fc.hp.com>
	<52840206.5020006@zytor.com>
	<20131113235708.GC25344@anatevka.fc.hp.com>
	<CAOJsxLFkHQ6_f+=CMwfNLykh59TZH5VrWeVEDPCWPF1wiw7tjQ@mail.gmail.com>
	<20131114180455.GA32212@anatevka.fc.hp.com>
Date: Thu, 14 Nov 2013 20:44:04 +0200
X-Google-Sender-Auth: ihA2R70NjSZUc3WRyvjw_SH2Pjs
Message-ID: <CAOJsxLFWMi8DoFp+ufri7XoFO27v+2=0oksh8+NhM6P-OdkOwg@mail.gmail.com>
Subject: Re: [PATCH 0/3] Early use of boot service memory
From: Pekka Enberg <penberg@kernel.org>
To: Jerry Hoemann <jerry.hoemann@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86 maintainers <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "list@ebiederm.org:DOCUMENTATION <linux-doc@vger.kernel.org>,
	list@ebiederm.org:MEMORY MANAGEMENT <linux-mm@kvack.org>," 
	<linux-doc@vger.kernel.org>,
        linux-efi@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 8:04 PM,  <jerry.hoemann@hp.com> wrote:
> Making this issue a quirk will be a lot more practical.  Its a small, focused
> change whose implications are limited and more easily understood.

There's nothing practical with requiring users to pass a kernel option
to make kdump work.  It's a workaround, sure, but it's not a proper
fix.

And once you add whitelisting to make it practical, implications are
no longer limited nor easily understood nor actually testable unless
you happen to have access every single firmware out there.

Yes, we have plenty of quirks in the x86 boot code but that doesn't
mean it's a good idea to add more of the unless we absolutely must.

                                Pekka
