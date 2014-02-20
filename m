Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbaBTWHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 17:07:01 -0500
Received: from relay3.sgi.com ([192.48.152.1]:55690 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752412AbaBTWHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 17:07:00 -0500
Date: Thu, 20 Feb 2014 16:06:57 -0600
From: Russ Anderson <rja@sgi.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minyard@acm.org" <minyard@acm.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Message-ID: <20140220220656.GT17949@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <1392740909-2079-1-git-send-email-matthew.garrett@nebula.com> <20140220201458.GA7099@sgi.com> <1392927381.20109.0.camel@x230> <20140220204028.GJ17949@sgi.com> <1392929163.20109.5.camel@x230> <20140220205901.GM17949@sgi.com> <1392930047.20109.6.camel@x230> <20140220212854.GO17949@sgi.com> <1392932363.20109.11.camel@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392932363.20109.11.camel@x230>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 09:39:23PM +0000, Matthew Garrett wrote:
> On Thu, 2014-02-20 at 15:28 -0600, Russ Anderson wrote:
> 
> > For some customers _any_ amount is significant, especially
> > on large clustered systems where the amount is multiplied
> > by tens or hundreds of thousands of nodes.
> > 
> > You many not think wasting their cpu cycles is important, but they do.
> 
> Then they should be running locally built kernels in order to ensure

Why don't YOU run a locally built kernel?

> that there's no problematic code running at all. Distribution kernels
> will always contain code that some customers won't be interested in, and
> some of that code will end up executing.

We support multiple distros so if one does something the customer
does not like/need we can steer them to other distros.

> If you have specific bug reports, that would be helpful. But you're not
> describing actual failure conditions or showing any willingness to
> figure out what the underlying problem is.

You can't fix your problem without creating problems for
others to fix?


-- 
Russ Anderson,  Kernel and Performance Software Team Manager
SGI - Silicon Graphics Inc          rja@sgi.com
