Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbaICWZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:25:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:30710 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756891AbaICWZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:25:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,460,1406617200"; 
   d="scan'208";a="585894457"
Message-ID: <5407955C.3040501@intel.com>
Date: Wed, 03 Sep 2014 15:25:32 -0700
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: RFC: Tainting the kernel on raw I/O access
References: <5407863B.9030608@intel.com> <20140903232018.17bba503@alan.etchedpixels.co.uk>
In-Reply-To: <20140903232018.17bba503@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 03:20 PM, One Thousand Gnomes wrote:
> 
> If you just want some "detector bits" for bug report filtering them its
> quite a different need to fixing "secure" boot mode. Even in the detector
> bits case there should be an overall plan and some defined properties
> that provide the security and which you can show should always be true.
> 

As far as I'm concerning this is just a set of "detector bits".  My
observation was simply that this is a *subset* of what "secure boot"
will eventually need.

Secure boot will need the error path no matter what... tainting
obviously doesn't.

(As far as I'm concerned, I'd be happy tainting the kernel for any
operation that requires CAP_RAWIO, but maybe that is too extreme.)

	-hpa


