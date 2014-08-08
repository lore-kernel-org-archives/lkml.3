Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125AbaHHVrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:47:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:37242 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759105AbaHHVrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:47:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,827,1400050800"; 
   d="scan'208";a="585489463"
Message-ID: <53E54533.8030109@linux.intel.com>
Date: Fri, 08 Aug 2014 14:46:27 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Amit Shah <amit.shah@redhat.com>
CC: jgarzik@bitpay.com,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Amos Kong <akong@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Subject: Re: [PATCH 1/2] rngd: add udev rule to source from hwrng if virtio-rng
 present
References: <cover.1407416628.git.amit.shah@redhat.com> <dd2ddb8458e5ab5cffceb7fac2e3f71e9e2197f3.1407416628.git.amit.shah@redhat.com> <53E3D3FF.70707@linux.intel.com> <20140808090715.GG14400@grmbl.mre>
In-Reply-To: <20140808090715.GG14400@grmbl.mre>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 02:07 AM, Amit Shah wrote:
>
> 
>>  To
>> some degree the above is obsolete when we get khwrngd widely deployed,
>> but that is a new-kernel-only kind of thing.
> 
> Right - I'm wondering if any such changes as propsed here are now
> obsolted already by khwrngd?
> 

In this case, yes, khwrngd would be a better solution for current kernels.

	-hpa


