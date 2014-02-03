Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbaBCUij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 15:38:39 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:59234 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaBCUii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 15:38:38 -0500
MIME-Version: 1.0
In-Reply-To: <1391445367.3509.30.camel@linaro1.home>
References: <1390507559-4697-1-git-send-email-dave.long@linaro.org>
 <1390507559-4697-16-git-send-email-dave.long@linaro.org> <1391445367.3509.30.camel@linaro1.home>
From: Rabin Vincent <rabin@rab.in>
Date: Mon, 3 Feb 2014 21:37:56 +0100
X-Google-Sender-Auth: d6fKqShFfh7I15T5wB7hxN3nOac
Message-ID: <CAH+eYFAW=6+bzS7fiPM6G+b3GA6HMf7pOVxEusFSGHmGmZG1RQ@mail.gmail.com>
Subject: Re: [PATCH v5 15/16] ARM: add uprobes support
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>, David Long <dave.long@linaro.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        davem@davemloft.net, Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-03 Jon Medhurst (Tixy) <tixy@linaro.org>:
> On Thu, 2014-01-23 at 15:05 -0500, David Long wrote:
> > From: "David A. Long" <dave.long@linaro.org>
> >
> > Using Rabin Vincent's ARM uprobes patches as a base, enable uprobes
> > support on ARM.
> >
> > Caveats:
> >
> >  - Thumb is not supported
> >
> > Signed-off-by: David A. Long <dave.long@linaro.org>
>
> As this is based on Rabin's work, and the new files have his Copyright,
> then this patch also needs his 'Signed-off-by'. Rabin, I assume that you
> agree?

Don't know if it's needed, but if it is, you may certainly add it to
this patch, David:

  Signed-off-by: Rabin Vincent <rabin@rab.in>
