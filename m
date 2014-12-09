Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbaLICbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 21:31:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:31948 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190AbaLICbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 21:31:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,542,1413270000"; 
   d="scan'208";a="644577138"
Message-ID: <54865F05.2060103@intel.com>
Date: Tue, 09 Dec 2014 10:31:33 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Zhang Rui <rui.zhang@intel.com>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the thermal tree
References: <20141209131744.084929df@canb.auug.org.au>
In-Reply-To: <20141209131744.084929df@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the trouble.

Hi Rui,

Please let me know if you want an update to the original patch
or an incremental one.

Thanks,
Aaron

On 12/09/2014 10:17 AM, Stephen Rothwell wrote:
> Hi Zhang,
> 
> After merging the thermal tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/thermal/Kconfig:265: can't open file "drivers/thermal/int340x_thermal/Kconfig"
> 
> Caused by commit 4152c8bc018d ("Thermal: introduce INT3406 thermal
> driver").  Presumable a new file was missed.
> 
> I have used teh thermal tree from next-20141208 for today.
> 

