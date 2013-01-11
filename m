Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab3AKMmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 07:42:08 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49926 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752409Ab3AKMmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 07:42:07 -0500
Date: Fri, 11 Jan 2013 13:41:29 +0100
From: Florian Westphal <fw@strlen.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Florian Westphal <fw@strlen.de>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, gaowanlong@cn.fujitsu.com,
        gregkh@linuxfoundation.org, frank@lichtenheld.de
Subject: Re: regression, bisected: openpty fails from 3.7 onwards without
 devpts
Message-ID: <20130111124129.GA23516@breakpoint.cc>
References: <20130110144626.GA26279@breakpoint.cc>
 <20130110155058.12f66e73@bob.linux.org.uk>
 <20130110162907.GB26279@breakpoint.cc>
 <50EEF8FD.9000004@suse.cz>
 <20130110224554.1724a791@bob.linux.org.uk>
 <50EF45DF.4010905@suse.cz>
 <50EFF366.2000303@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EFF366.2000303@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jslaby@suse.cz> wrote:
> On 01/10/2013 11:51 PM, Jiri Slaby wrote:
> > On 01/10/2013 11:45 PM, Alan Cox wrote:
> >> So we should just fix TIOCGPTN on a pty with no suitable name answer to
> >> return -EINVAL
> > 
> > Yes, I agree as I'm expressed in my second mail. Sorry for the confusion.
> 
> Does the attached patch help?

Yes, it does.  Thanks for fixing this.
