Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab3J1U7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 16:59:12 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:55896 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756885Ab3J1U7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 16:59:10 -0400
In-Reply-To: <20131028201735.GA15629@redhat.com>
References: <12083.1382486094@ale.ozlabs.ibm.com> <20131023141948.GB3566@localhost.localdomain> <20131025173749.GG19466@laptop.lan> <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com> <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com> <20131028132634.GO19466@laptop.lan> <20131028163418.GD4126@linux.vnet.ibm.com> <20131028201735.GA15629@redhat.com>
Subject: Re: perf events ring buffer memory barrier on powerpc
X-KeepSent: 58D85F5A:03E37A80-42257C12:0070E552;
 type=4; name=$KeepSent
To: Oleg Nesterov <oleg@redhat.com>
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com>
From: Victor Kaplansky <VICTORK@il.ibm.com>
Date: Mon, 28 Oct 2013 22:58:58 +0200
X-MIMETrack: Serialize by Router on D06ML319/06/M/IBM(Release 8.5.3FP5|July 31, 2013) at
 28/10/2013 22:58:51
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102820-8372-0000-0000-00000799794E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote on 10/28/2013 10:17:35 PM:

>       mb();   // XXXXXXXX: do we really need it? I think yes.

Oh, it is hard to argue with feelings. Also, it is easy to be on
conservative side and put the barrier here just in case.
But I still insist that the barrier is redundant in your example.

-- Victor

