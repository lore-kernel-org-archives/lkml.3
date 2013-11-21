Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab3KUBsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 20:48:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:62652 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab3KUBso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 20:48:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,740,1378882800"; 
   d="scan'208";a="437008416"
Message-ID: <528D6665.60809@linux.intel.com>
Date: Wed, 20 Nov 2013 17:48:21 -0800
From: sathyanarayanan kuppuswamy 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Reply-To: sathyanarayanan.kuppuswamy@linux.intel.com
Organization: Intel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
        "david.a.cohen@linux.intel.com" <david.a.cohen@linux.intel.com>,
        "eric.ernst@linux.intel.com" <eric.ernst@linux.intel.com>
Subject: Re: [PATCH v2.2] ipc: Added support for IPC interrupt mode
References: <1384561314-11210-1-git-send-email-david.a.cohen@linux.intel.com>	 <1384998333-141121-1-git-send-email-sathyanarayanan.kuppuswamy@linux.intel.com> <1384998432.20536.14.camel@x230>
In-Reply-To: <1384998432.20536.14.camel@x230>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/20/2013 05:47 PM, Matthew Garrett wrote:
> On Wed, 2013-11-20 at 17:45 -0800, Kuppuswamy Sathyanarayanan wrote:
>
>>   - Changed INIT_COMPLETION to reinit_completion.
> Thanks, I've already folded that fix into the patch and re-pushed.
>
Thanks.

--
Sathyanarayanan Kuppuswamy
Android kernel developer

