Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445AbaLAULi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:11:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49720 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101AbaLAULh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:11:37 -0500
Date: Mon, 1 Dec 2014 21:11:51 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Huang Bo <huangbobupt@163.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/1] HID: add BETOP game controller force feedback
 support
In-Reply-To: <5477CDD4.8000908@163.com>
Message-ID: <alpine.LNX.2.00.1412012111020.2524@pobox.suse.cz>
References: <54768284.4060201@163.com> <alpine.LNX.2.00.1411271004260.23174@pobox.suse.cz> <5477CDD4.8000908@163.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2014, Huang Bo wrote:

> On 11/27/2014 05:05 PM, Jiri Kosina wrote:
> > except ...
> thanks firstly.
> 1. tested the BETOP2185 gamecontroller, it really not need it.
> 2. check with engineers of Betop, they design only one report descriptor.
> 
> so I modify it.

Thanks, but please put the comment into the code (jus before you are 
zeroing the fields), so that it's immediately obvious to everybody who is 
reading the code.

Other than that, I am OK with the patch and will be applying it once you 
resend it with the comments added.

Thanks,

-- 
Jiri Kosina
SUSE Labs
