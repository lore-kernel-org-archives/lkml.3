Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab3FDOoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:44:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16219 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205Ab3FDOn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:43:59 -0400
X-Authority-Analysis: v=2.0 cv=BcJaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=UfnZSsE0JEEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=Ss263ASI6nMA:10 a=ayC55rCoAAAA:8 a=VNlkHCOS18w3GnkVV0oA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370357038.26799.121.camel@gandalf.local.home>
Subject: Re: [09/65] math64: New div64_u64_rem helper
From: Steven Rostedt <rostedt@goodmis.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 04 Jun 2013 10:43:58 -0400
In-Reply-To: <20130604134508.GB17229@redhat.com>
References: <20130603221016.243553628@goodmis.org>
	 <20130603221153.655422077@goodmis.org> <20130604134508.GB17229@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-04 at 15:45 +0200, Stanislaw Gruszka wrote:
> On Mon, Jun 03, 2013 at 06:10:25PM -0400, Steven Rostedt wrote:
> > 3.6.11.5 stable review patch.
> > If anyone has any objections, please let me know.
> 
> If you will not pull other commits (I do not see them in the set):
> 
> d9a3c9823a2e6a543eb7807fb3d15d8233817ec5
> 55eaa7c1f511af5fb6ef808b5328804f4d4e5243
> 772c808a252594692972773f6ee41c289b8e0b2a
> f3002134158092178be81339ec5a22ff80e6c308
> 68aa8efcd1ab961e4684ef5af32f72a6ec1911deA

Yeah, they didn't apply well at all.

> 
> this one is not necessary and actually hit performance a bit.

Thanks, I'll remove it.

-- Steve


