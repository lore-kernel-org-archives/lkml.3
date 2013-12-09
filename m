Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761229Ab3LIJnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:43:47 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:18184 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761209Ab3LIJno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:43:44 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 09 Dec 2013 01:36:51 -0800
Message-ID: <52A590CC.4040703@nvidia.com>
Date: Mon, 9 Dec 2013 18:43:40 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
Subject: Re: [PATCH] SFI: remove wrong FSF address from the license
References: <1386581527-28907-1-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1386581527-28907-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 06:32 PM, Andy Shevchenko wrote:
> Remove old and currently wrong address of the FSF from license parts of the
> code.

The address is not wrong, it is just that you don't want to see it 
become wrong should it change in the future.
