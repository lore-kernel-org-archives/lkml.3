Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab3HZUKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 16:10:39 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:26949 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab3HZUKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 16:10:38 -0400
Date: Mon, 26 Aug 2013 22:10:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Yang, Fei" <fei.yang@intel.com>
Cc: "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>
Subject: Re: Can anyone suggest a better fix? Not sure if I understand the
	problem, but the patch fixed it
Message-ID: <20130826201035.GA21141@merkur.ravnborg.org>
References: <02E7334B1630744CBDC55DA85862258348E431C1@ORSMSX102.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02E7334B1630744CBDC55DA85862258348E431C1@ORSMSX102.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 07:22:46PM +0000, Yang, Fei wrote:
> >From 5e6501efa26bc19dad0b43e3a2b0daa81408a8ae Mon Sep 17 00:00:00 2001
> From: Fei Yang <fei.yang@intel.com>
> Date: Mon, 26 Aug 2013 11:21:48 -0700
> Subject: [PATCH] FIXDEP: error opening depfile
>  
> Met a kernel build issue where fixdep fails to open a depfile,
> fixdep: error opening depfile: drivers/driver-name/.driver-code.o.d: No such file or directory
> make[4]: *** [drivers/driver-name/driver-code.o] Error 2
> make[3]: *** [drivers/driver-name] Error 2
> Don't know why the expected file was not created, but the assumption that
> the file had been created might not be true, so simply return for such failure.

I tried to grep:
git grep "driver-name"

No hits.

Are you trying to fix a build issue with something out-of-tree - or is this only in linux-next?

	Sam
