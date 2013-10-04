Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab3JDXZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 19:25:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:16695 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab3JDXZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 19:25:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1036,1371106800"; 
   d="scan'208";a="370035353"
Date: Fri, 4 Oct 2013 16:25:03 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        gregkh@linuxfoundation.org, len.brown@intel.com, rjw@sisk.pl,
        arjan@linux.intel.com
Subject: Re: [PATCH v2 6/6] Introduce Intel RAPL power capping driver
Message-ID: <20131004162503.07ec349a@ultegra>
In-Reply-To: <1380924862.2081.118.camel@joe-AO722>
References: <1380904616-17519-1-git-send-email-srinivas.pandruvada@linux.intel.com>
	<1380904616-17519-7-git-send-email-srinivas.pandruvada@linux.intel.com>
	<1380910065.2081.117.camel@joe-AO722>
	<20131004131228.54eb7098@ultegra>
	<1380924862.2081.118.camel@joe-AO722>
Organization: OTC
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Oct 2013 15:14:22 -0700
Joe Perches <joe@perches.com> wrote:

> Isn't LIMIT1/WINDOW1 used as ull anyway?
> It doesn't hurt to show that the value is also ull.
sure, I will make that change in the next set.

thanks,

Jacob
