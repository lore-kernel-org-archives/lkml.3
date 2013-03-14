Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934499Ab3CNC6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 22:58:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23502 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934386Ab3CNC6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 22:58:20 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ycACizqO-ZYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=os3rqKFAMDIA:10 a=6PW3aCyAGem-W5z-vLgA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363229899.25967.27.camel@gandalf.local.home>
Subject: Re: Question about a patch for stable
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 13 Mar 2013 22:58:19 -0400
In-Reply-To: <20130314024819.GB9342@kroah.com>
References: <1363226945.25967.25.camel@gandalf.local.home>
	 <20130314024819.GB9342@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-13 at 19:48 -0700, Greg Kroah-Hartman wrote:

> I always defer to the maintainer of the subsystem, so it's up to you.

Great! I'll add them all :-)   It just irritates me when I do a stack
trace and see some strange results. Even when I know they are minor and
understand why they happen. But if they can be fixed, they should be!

-- Steve


