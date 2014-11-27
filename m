Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaK0Sq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 13:46:57 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:51927 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaK0Sq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 13:46:56 -0500
MIME-Version: 1.0
In-Reply-To: <20141127183616.GV25677@wotan.suse.de>
References: <1417040805-15857-1-git-send-email-mcgrof@do-not-panic.com>
 <5476C66F.5040308@suse.com> <20141127183616.GV25677@wotan.suse.de>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 27 Nov 2014 13:46:34 -0500
X-Google-Sender-Auth: EUNe-5SzN7_b565HIMtdBmMTRMU
Message-ID: <CAB=NE6Xt3QhuKvUm-+-iD4pThsmLZ7oq1nnQbL0Hcw8Q0fpEqw@mail.gmail.com>
Subject: Re: [PATCH] xen: privcmd: schedule() after private hypercall when non CONFIG_PREEMPT
To: Juergen Gross <jgross@suse.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86@kernel.org, kvm@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>,
        Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@suse.de>,
        Jan Beulich <JBeulich@suse.com>, Olaf Hering <ohering@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 1:36 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> I'm afraid we don't have much leg room.

Let me be clear, I still think putting some hypercalls in process
context *might help* but because of notes 1) and 2) I highlighted I
think this is the best we can do, with more information we should be
able to consider weighing pros / cons with actual metrics from
alternatives, without more information we're just shooting in the dark
and the last thing I want is to see APIs abused or setting precedents.

  Luis
