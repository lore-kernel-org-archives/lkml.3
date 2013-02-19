Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698Ab3BSMOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 07:14:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6255 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932530Ab3BSMOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 07:14:53 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=TL2E3K3wEE3QBc_YWw4A:9 a=CjuIK1q_8ugA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Date: Tue, 19 Feb 2013 07:14:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-next@vger.kernel.org
Subject: Re: Linux 3.8
Message-ID: <20130219121450.GC9161@home.goodmis.org>
References: <CA+55aFwdyYa0ajqgzUoAQmUD2frBe2-gvxgny_9gD6PCoOYrqw@mail.gmail.com>
 <20130219131515.8d59aeeb8023ed5d0bfc620b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130219131515.8d59aeeb8023ed5d0bfc620b@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 01:15:15PM +1100, Stephen Rothwell wrote:
> 
> So, presumably the merge window is open and Linus will start pulling
> trees shortly.  So, here I go again:
> 
> Please do *not* rebase your tree before asking Linus to pull it.

Grumble, I did a small rebase after the window opened but before I knew
it did. The rebase was just to add an "Acked-by" to the change log and
no code change what so ever. I put it into linux-next to get testing
while waiting on the ack, and after the ack, I pushed it to Ingo.

Original commit: 5ec8d0104fd81d86cb7386c228e73ae635f1d74d
After Ack added: 8c189ea64eea01ca20d102ddb74d6936dd16c579

Feel free to do the diff.

-- Steve

