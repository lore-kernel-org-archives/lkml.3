Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab3GVLSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 07:18:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932238Ab3GVLSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 07:18:21 -0400
Date: Mon, 22 Jul 2013 13:18:18 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [x86] Kernel panic - not syncing: Fatal exception in interrupt
In-Reply-To: <abe9f13f-3d25-4577-b5f8-8e40eb2cb3f2@email.android.com>
Message-ID: <alpine.LNX.2.00.1307221317510.23128@pobox.suse.cz>
References: <20130720131226.GA13893@localhost> <51EB29FD.60508@zytor.com> <alpine.LNX.2.00.1307211004100.31632@pobox.suse.cz> <abe9f13f-3d25-4577-b5f8-8e40eb2cb3f2@email.android.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Jul 2013, H. Peter Anvin wrote:

> Honestly, why don't we make the patch list (rbtree, whatever) a 
> permanent part of the default breakpoint handler.  It only applies to 
> kernel space anyway and the kernel doesn't have any permanent 
> breakpoints so there should be no performance reason not to.

That is actually quite a nice idea, and I am putting it on my TODO list 
for ftrace conversion.

Thanks,

-- 
Jiri Kosina
SUSE Labs
