Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762442Ab3JQTjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 15:39:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:26173 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758172Ab3JQTjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 15:39:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,516,1378882800"; 
   d="scan'208";a="412813796"
Message-ID: <52603CD6.6080507@linux.intel.com>
Date: Thu, 17 Oct 2013 12:39:02 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Corrupted low memory in v3.9+
References: <CAOesGMgV2UsBffPveaE+j1s-mDZ+cQvvQGLGAXjWSAv+a_56Fw@mail.gmail.com>
In-Reply-To: <CAOesGMgV2UsBffPveaE+j1s-mDZ+cQvvQGLGAXjWSAv+a_56Fw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2013 11:57 AM, Olof Johansson wrote:
> 
> And the low memory checker never even ran before, since it had nothing
> to check. Earlier the lower reserved region would be included in the
> e820-reserved area if I read the code correctly, and now it's just
> marked reserved by the memblock code.
> 
> I guess it could be argued either way whether this is a regression or
> not; but at the end of the day we now have systems where this warning
> pops when it didn't use to. :(
> 

I'm wondering if this is a problem with the low memory checker (the
residual value of which I have to admit to being skeptical of) or
something else.

Could you boot the box with "debug memblock=debug" and earlyprintk
turned on and send the boot output?

	-hpa


