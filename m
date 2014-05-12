Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774AbaELDp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 23:45:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:47480 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbaELDpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 23:45:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1032,1389772800"; 
   d="scan'208";a="537442430"
Message-ID: <537043D4.8070301@linux.intel.com>
Date: Sun, 11 May 2014 20:45:24 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephan Mueller <smueller@chronox.de>
CC: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: arch_random_refill
References: <21542339.0lFnPSyGRS@myon.chronox.de> <53703E74.9020700@linux.intel.com> <3260147.sUis3H5ONm@myon.chronox.de>
In-Reply-To: <3260147.sUis3H5ONm@myon.chronox.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2014 08:36 PM, Stephan Mueller wrote:
> 
> But in our current predicament, not everybody trusts a few potentially easily 
> manipulated gates that have no other purpose than produce white noise which 
> are developed by the biggest chip vendor in the US. Gates which have other 
> purposes may not be that easily manipulated.
>

Incidentally, I disagree with the "easily manipulated" bit.  Yes, I have
seen the paper which says that you can do it in such a way that it
doesn't show up on *visual* examination.  However, put an electrical
probe on it and it shows up immediately.

	-hpa


