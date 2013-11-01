Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab3KAQc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:32:26 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:45463 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab3KAQcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:32:24 -0400
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B73D4@saturn3.aculab.com>
References: <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com> <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com> <20131028132634.GO19466@laptop.lan> <20131028163418.GD4126@linux.vnet.ibm.com> <20131028201735.GA15629@redhat.com> <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com> <20131030092725.GL4126@linux.vnet.ibm.com> <OFC6B7100E.31C6B190-ON42257C14.004841C6-42257C14.004A0EA6@il.ibm.com> <20131031043258.GQ4126@linux.vnet.ibm.com> <OFDF23985D.1D949148-ON42257C15.002DEB25-42257C15.0036DF93@il.ibm.com> <20131031152543.GC4067@linux.vnet.ibm.com> <OF3CB471BA.BACC7843-ON42257C16.0055EF23-42257C16.0058875B@il.ibm.com> <AE90C24D6B3A694183C094C60CF0A2F6026B73D4@saturn3.aculab.com>
Subject: RE: perf events ring buffer memory barrier on powerpc
X-KeepSent: 57D6EF77:CD2E45CE-42257C16:005AA6D8;
 type=4; name=$KeepSent
To: "David Laight" <David.Laight@aculab.com>
Cc: "Anton Blanchard" <anton@samba.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "Linux PPC dev" <linuxppc-dev@ozlabs.org>,
        "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
        "Michael Neuling" <mikey@neuling.org>,
        "Oleg Nesterov" <oleg@redhat.com>, paulmck@linux.vnet.ibm.com,
        "Peter Zijlstra" <peterz@infradead.org>
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OF57D6EF77.CD2E45CE-ON42257C16.005AA6D8-42257C16.005AB961@il.ibm.com>
From: Victor Kaplansky <VICTORK@il.ibm.com>
Date: Fri, 1 Nov 2013 18:30:56 +0200
X-MIMETrack: Serialize by Router on D06ML319/06/M/IBM(Release 8.5.3FP5|July 31, 2013) at
 01/11/2013 18:30:49
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110116-3548-0000-0000-000007047170
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"David Laight" <David.Laight@aculab.com> wrote on 11/01/2013 06:25:29 PM:
> gcc will do unexpected memory accesses for bit fields that are
> adjacent to volatile data.
> In particular it may generate 64bit sized (and aligned) RMW cycles
> when accessing bit fields.
> And yes, this has caused real problems.

Thanks, I am aware about this bug/feature in gcc.
-- Victor

