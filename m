Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab3AYKNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:13:55 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44370 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415Ab3AYKNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:13:51 -0500
Date: Fri, 25 Jan 2013 11:16:40 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, fweisbec@gmail.com, rusty@rustcorp.com.au,
        ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
        masami.hiramatsu.pt@hitachi.com, jbaron@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        MartinSchwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: [PATCH 2/5] jump label: constify lookup functions
Message-ID: <20130125101640.GA32419@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Sasha Levin <sasha.levin@oracle.com>,
	Steven Rostedt <rostedt@goodmis.org>, tglx@linutronix.de,
	mingo@redhat.com, hpa@zytor.com, fweisbec@gmail.com,
	rusty@rustcorp.com.au, ananth@in.ibm.com,
	anil.s.keshavamurthy@intel.com, masami.hiramatsu.pt@hitachi.com,
	jbaron@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
	MartinSchwidefsky <schwidefsky@de.ibm.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	linux-s390 <linux-s390@vger.kernel.org>
References: <1357772960-4436-1-git-send-email-sasha.levin@oracle.com>
 <1357772960-4436-2-git-send-email-sasha.levin@oracle.com>
 <1358544300.7383.37.camel@gandalf.local.home>
 <510206CE.9050804@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <510206CE.9050804@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 11:15:10PM -0500, Sasha Levin wrote:
> Sorry about this. I didn't have the ability to build all arches over here :(

Seen this already: https://www.kernel.org/pub/tools/crosstool/

?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
