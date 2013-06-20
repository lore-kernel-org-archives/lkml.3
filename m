Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965595Ab3FTSed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 14:34:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19945 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965316Ab3FTSeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 14:34:31 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=EVMdXO81WbgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=3fLAnx-yVNQA:10 a=YwAs0XXliERhoHWHYpkA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371753270.18733.99.camel@gandalf.local.home>
Subject: Re: [for-next][PATCH 08/12] tracing: Add binary & filter for events
From: Steven Rostedt <rostedt@goodmis.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 20 Jun 2013 14:34:30 -0400
In-Reply-To: <51C349BD.4030403@broadcom.com>
References: <20130620033516.003166252@goodmis.org>
	 <20130620033639.723900482@goodmis.org> <51C2B8AB.8060709@broadcom.com>
	 <1371730487.18733.72.camel@gandalf.local.home>
	 <51C349BD.4030403@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 20:28 +0200, Arend van Spriel wrote:

> Reading the whole text with your remark in mind, I guess it does 
> indicate there are no guarantees depending on the kernel and the list of 
> operators are what trace-cmd supports. I overlooked/ignored the text 
> seeing the operators.

Exactly, which means that if you over looked the text, so has others.
The text 
should be changed to make it more comprehensible.

I also have a lot of other trace-cmd changes that I have not yet pushed
to my git repo. I'm just not comfortable with the changes quite yet. And
it's blocking some changes that I have no issue with. Hmm, I should just
rebase and push, but I'm using this as motivation to get those changes
tested enough ;-)

Thanks,

-- Steve


