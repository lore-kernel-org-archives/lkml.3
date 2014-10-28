Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaJ1M4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:56:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbaJ1M4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:56:08 -0400
Date: Tue, 28 Oct 2014 08:55:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Fabian Frederick <fabf@skynet.be>, isimatu.yasuaki@jp.fujitsu.com,
        linux-doc@vger.kernel.org, kexec@lists.infradead.org,
        linux-api@vger.kernel.org, jason.wessel@windriver.com
Subject: Re: [PATCH V4] kernel, add bug_on_warn
Message-ID: <20141028125534.GC10632@redhat.com>
References: <1414155207-29839-1-git-send-email-prarit@redhat.com>
 <20141028121636.GC3274@tassilo.jf.intel.com>
 <544F8A78.9070008@redhat.com>
 <20141028122900.GA10632@redhat.com>
 <20141028124425.GD3274@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028124425.GD3274@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 05:44:25AM -0700, Andi Kleen wrote:
> > > I suppose ... but that would mean I would have to explain to an end user the
> > > elaborate process of enabling kdb, inserting a break point, etc.  The whole
> > > purpose of this is to let an end user panic on WARN() easily.
> > > 
> > > Asking an end user to enable kdb is magnitudes worse than asking them to
> > > recompile a kernel.
> > 
> > Agreed. Asking a customer to setup and run kdb and put breakpoints is much
> > more pain than simply asking to reboot kernel with a command line option.
> 
> If you have a command line option to execute kdb commands you still
> would only have a command line option, just a slightly longer one.
> 
> kdb="on, bp warn_slowpath_common sr c, go" 

So does it already work or proposal is to make something like this work
with kdb?

What about the case of enabling it post boot and using a /sys file for 
that.

Thanks
Vivek
