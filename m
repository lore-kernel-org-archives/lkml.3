Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab3C0QiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:38:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58890 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab3C0QiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:38:11 -0400
Date: Wed, 27 Mar 2013 17:38:06 +0100
From: Borislav Petkov <bp@alien8.de>
To: Joerg Roedel <joro@8bytes.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 asm/8267
Message-ID: <20130327163806.GC8385@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Joerg Roedel <joro@8bytes.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Arnaldo Carvalho de Melo <acme@infradead.org>,
	lkml <linux-kernel@vger.kernel.org>,
	Stephane Eranian <eranian@google.com>,
	Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>
References: <20130324115556.GA4866@pd.tnic>
 <20130324155924.GB4866@pd.tnic>
 <20130326183452.GC27518@pd.tnic>
 <20130327131532.GL30540@8bytes.org>
 <1364393852.5053.74.camel@laptop>
 <20130327143715.GY4379@linux.vnet.ibm.com>
 <20130327163427.GN30540@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130327163427.GN30540@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 05:34:27PM +0100, Joerg Roedel wrote:
> Interesting read, thanks guys. I think I should have a look into the
> tree-preempt implementation and try to understand it :)

Hurry, before paulmck comes and changes it unrecognizable! :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
