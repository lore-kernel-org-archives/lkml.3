Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab3CRN0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 09:26:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27272 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab3CRN02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 09:26:28 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ymFTQ-8wQ_EA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=4oK4ZT3GD4UA:10 a=CWo4AS-AAAAA:8 a=Wdj64zOUYXBRZrw2r8gA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363613187.25967.140.camel@gandalf.local.home>
Subject: Re: linux-next: manual merge of the ftrace tree with Linus' tree
From: Steven Rostedt <rostedt@goodmis.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 18 Mar 2013 09:26:27 -0400
In-Reply-To: <20130318130014.bad6e49cd6d4a112050173de@canb.auug.org.au>
References: <20130318130014.bad6e49cd6d4a112050173de@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 13:00 +1100, Stephen Rothwell wrote:
> Hi Steven,
> 
> Today's linux-next merge of the ftrace tree got a conflict in
> kernel/trace/ftrace.c between commit b67bfe0d42ca ("hlist: drop the node
> parameter from iterators") from Linus' tree and commit e1df4cb682ab
> ("ftrace: Fix function probe to only enable needed functions") from the
> ftrace tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 

Looks fine, thanks.

-- Steve


