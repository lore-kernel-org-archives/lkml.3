Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab3J3M6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 08:58:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab3J3M6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 08:58:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <52705CC0.8020909@asianux.com>
References: <52705CC0.8020909@asianux.com> <523FD9E7.3050303@asianux.com> <523FDBD7.4040602@asianux.com> <C2D7FE5348E1B147BCA15975FBA2307514DED9@IN01WEMBXA.internal.synopsys.com> <523FE578.5060801@asianux.com> <52672DAC.1030307@asianux.com> <CAMqJFCou4SObPni5Lb_tX=0hQ__kF_9MLDC-6a1opptc9dxT-A@mail.gmail.com> <52673E41.6040606@asianux.com> <5267AF98.1010800@asianux.com> <5268B0B1.9050009@asianux.com> <526F1ACE.7080409@asianux.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: dhowells@redhat.com, Joern Rennecke <joern.rennecke@embecosm.com>,
        James Hogan <james.hogan@imgtec.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Takashi Iwai <tiwai@suse.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "jeremy.bennett@embecosm.com" <jeremy.bennett@embecosm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Claudiu Zissulescu <Claudiu.Zissulescu@synopsys.com>,
        Francois Bedard <Francois.Bedard@synopsys.com>,
        Max Filippov <jcmvbkbc@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH-next v3] kernel/system_certificate.S: use real contents instead of macro GLOBAL()
Date: Wed, 30 Oct 2013 12:57:45 +0000
Message-ID: <30128.1383137865@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang <gang.chen@asianux.com> wrote:

> If a macro is only used within 2 times, and also its contents are
> within 2 lines, recommend to expand it to shrink code line.
> 
> For our case, the macro is not portable either: some architectures'
> assembler may use another character to mark newline in a macro (e.g.
> '`' for arc), which will cause issue.
> 
> If still want to use macro and let it portable enough, it will also
> need include additional header file (e.g "#include <linux/linkage.h>",
> although it also need be fixed).

Fine by me.

Applied.
