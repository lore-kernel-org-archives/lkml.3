Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbaJ1Cdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 22:33:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbaJ1Cdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 22:33:36 -0400
Date: Tue, 28 Oct 2014 10:32:51 +0800
From: Dave Young <dyoung@redhat.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Jason Baron <jbaron@akamai.com>, Andi Kleen <ak@linux.intel.com>,
        Jonathan Corbet <corbet@lwn.net>, kexec@lists.infradead.org,
        Rusty Russell <rusty@rustcorp.com.au>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fabian Frederick <fabf@skynet.be>,
        isimatu.yasuaki@jp.fujitsu.com, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org,
        vgoyal@redhat.com
Subject: Re: [PATCH V4] kernel, add bug_on_warn
Message-ID: <20141028023251.GD3329@darkstar.nay.redhat.com>
References: <1414155207-29839-1-git-send-email-prarit@redhat.com>
 <544E8985.50203@akamai.com>
 <544E8BB8.8000707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544E8BB8.8000707@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Seems reasonable-I'm wondering why you just don't call panic() in this
> > case. The BUG() call at line '434' doesn't at anything since its just being
> > called from panic.c.
> 
> Hmm ... I didn't even think about that.
> 
> > 
> > So something like 'panic_on_warn' would seem to be more appropriate
> > in keeping with things like 'panic_on_oops' or 'panic_on_stackoverflow'.
> 
> I like it a lot better that way too :)  I'm changing it to panic_on_warn unless
> anyone has any strenuous objections.

I would vote for panic_on_warn, it will make more sense than bug_on_warn.

Thanks
Dave
