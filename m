Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbbANQap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:30:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:24930 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbbANQan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:30:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,756,1413270000"; 
   d="scan'208";a="651071946"
Message-ID: <1421253036.23184.4.camel@linux.intel.com>
Subject: Re: [tpmdd-devel] Question about duplicate definitions of
 transmit_cmd in tpm-sysfs.c and tmp-interface.c
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: nick <xerofoify@gmail.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        ashley@ashleylai.com
Date: Wed, 14 Jan 2015 18:30:36 +0200
In-Reply-To: <54A63F2D.4020803@gmail.com>
References: <549E530B.7040301@gmail.com>
	 <20150102063649.GB24953@obsidianresearch.com> <54A63F2D.4020803@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-02 at 01:48 -0500, nick wrote:
> Jason,
> Just a little nitpick but Jarkoo seems to have missed removing the function
> prototype, tpm_transmit as nothing uses this function anymore.

tpm-dev.c does.

> Regards Nick

/Jarkko

> 
> On 2015-01-02 01:36 AM, Jason Gunthorpe wrote:
> > On Sat, Dec 27, 2014 at 01:34:51AM -0500, nick wrote:
> > 
> >> After reading the code and trying various ways to merge these
> >> functions into tpm.h. I am wondering if the merge is really a good
> >> idea as it seems to break a lot of code that is very hard to trace
> >> and redo correctly without a lot of work. Further more I am curious
> >> as to why the merge is even useful as it seems unneeded to me other
> >> then to unify the function definitions which seems a minor detail to
> >> me.
> > 
> > Jarkko has already sent a patch to merge them, I think you can see the
> > to be merged patch here:
> > 
> > https://github.com/PeterHuewe/linux-tpmdd/commit/6e01df24a659c5f21d6beabf9b7a20a85f470cf4
> > 
> > If you see a problem with it please remark..
> > 
> > Jason
> > 
> 
> ------------------------------------------------------------------------------
> Dive into the World of Parallel Programming! The Go Parallel Website,
> sponsored by Intel and developed in partnership with Slashdot Media, is your
> hub for all things parallel software development, from weekly thought
> leadership blogs to news, videos, case studies, tutorials and more. Take a
> look and join the conversation now. http://goparallel.sourceforge.net
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel



