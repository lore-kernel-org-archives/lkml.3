Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750773AbbABGhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 01:37:00 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:56952 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbbABGg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 01:36:59 -0500
Date: Thu, 1 Jan 2015 23:36:49 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: nick <xerofoify@gmail.com>
Cc: peterhuewe@gmx.de, tpmdd-devel@lists.sourceforge.net, ashley@ashleylai.com,
        linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] Question about duplicate definitions of
 transmit_cmd in tpm-sysfs.c and tmp-interface.c
Message-ID: <20150102063649.GB24953@obsidianresearch.com>
References: <549E530B.7040301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <549E530B.7040301@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2014 at 01:34:51AM -0500, nick wrote:

> After reading the code and trying various ways to merge these
> functions into tpm.h. I am wondering if the merge is really a good
> idea as it seems to break a lot of code that is very hard to trace
> and redo correctly without a lot of work. Further more I am curious
> as to why the merge is even useful as it seems unneeded to me other
> then to unify the function definitions which seems a minor detail to
> me.

Jarkko has already sent a patch to merge them, I think you can see the
to be merged patch here:

https://github.com/PeterHuewe/linux-tpmdd/commit/6e01df24a659c5f21d6beabf9b7a20a85f470cf4

If you see a problem with it please remark..

Jason
