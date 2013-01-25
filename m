Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab3AYNDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:03:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33020 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101Ab3AYNDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:03:37 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=uNd_0Ub4VdcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Y3YARPKVEf4A:10 a=VwQbUJbxAAAA:8 a=xPpeZqOs3e9WaAAgpgMA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359119011.21576.212.camel@gandalf.local.home>
Subject: Re: [PATCH 2/5] jump label: constify lookup functions
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Sasha Levin <sasha.levin@oracle.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, fweisbec@gmail.com, rusty@rustcorp.com.au,
        ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
        masami.hiramatsu.pt@hitachi.com, jbaron@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        MartinSchwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Date: Fri, 25 Jan 2013 08:03:31 -0500
In-Reply-To: <20130125101640.GA32419@pd.tnic>
References: <1357772960-4436-1-git-send-email-sasha.levin@oracle.com>
	 <1357772960-4436-2-git-send-email-sasha.levin@oracle.com>
	 <1358544300.7383.37.camel@gandalf.local.home> <510206CE.9050804@oracle.com>
	 <20130125101640.GA32419@pd.tnic>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-25 at 11:16 +0100, Borislav Petkov wrote:
> On Thu, Jan 24, 2013 at 11:15:10PM -0500, Sasha Levin wrote:
> > Sorry about this. I didn't have the ability to build all arches over here :(
> 
> Seen this already: https://www.kernel.org/pub/tools/crosstool/

And look in the kernel tree:

  tools/testing/ktest/examples/crosstests.conf

-- Steve


