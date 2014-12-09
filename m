Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbaLICct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 21:32:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:48525 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbaLICcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 21:32:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="495790814"
Message-ID: <1418092358.12435.1.camel@rzhang1-toshiba>
Subject: Re: linux-next: build failure after merge of the thermal tree
From: Zhang Rui <rui.zhang@intel.com>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 09 Dec 2014 10:32:38 +0800
In-Reply-To: <54865F05.2060103@intel.com>
References: <20141209131744.084929df@canb.auug.org.au>
	 <54865F05.2060103@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-09 at 10:31 +0800, Aaron Lu wrote:
> Sorry for the trouble.
> 
> Hi Rui,
> 
> Please let me know if you want an update to the original patch
> or an incremental one.
> 
updated one
> Thanks,
> Aaron
> 
> On 12/09/2014 10:17 AM, Stephen Rothwell wrote:
> > Hi Zhang,
> > 
> > After merging the thermal tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> > 
> > drivers/thermal/Kconfig:265: can't open file "drivers/thermal/int340x_thermal/Kconfig"
> > 
> > Caused by commit 4152c8bc018d ("Thermal: introduce INT3406 thermal
> > driver").  Presumable a new file was missed.
> > 
> > I have used teh thermal tree from next-20141208 for today.
> > 
> 


