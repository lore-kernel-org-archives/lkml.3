Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbaFHSzj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 14:55:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55825 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbaFHSzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 14:55:38 -0400
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [GIT PULL] x86/vdso changes for v3.16
From: "H. Peter Anvin" <hpa@zytor.com>
X-Mailer: iPad Mail (11D201)
In-Reply-To: <20140608171848.GA19777@ravnborg.org>
Date: Sun, 8 Jun 2014 11:54:38 -0700
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "gorcunov@openvz.org" <gorcunov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "luto@amacapital.net" <luto@amacapital.net>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "sasha.levin@oracle.com" <sasha.levin@oracle.com>,
        "stefani@seibold.net" <stefani@seibold.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "xemul@parallels.com" <xemul@parallels.com>,
        "kbuild@vger.kernel.org" <kbuild@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <2794D90B-AE55-47F5-886A-E32E4CF557A6@zytor.com>
References: <201406042235.s54MZgwP020553@terminus.zytor.com> <20140606140017.afb7f91142f66cb3dd13c186@linux-foundation.org> <53922D7F.8090601@linux.intel.com> <20140608171848.GA19777@ravnborg.org>
To: Sam Ravnborg <sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Jun 8, 2014, at 10:18, Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> I would say that tools/include/tools/* should be considered the baseline
> for programs running on the host.
> So therefore unconditionally adding -I$(srctree)/tools/include should then
> be OK.
> 
>    Sam

I think we should do this, but I didn't yet because linux/types.h in that directory shadows uapi/linux/types.h which probably should be fixed first.

