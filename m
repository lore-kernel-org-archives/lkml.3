Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbaGaOqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 10:46:08 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56370 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaGaOqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 10:46:06 -0400
Date: Thu, 31 Jul 2014 11:45:48 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@kernel.org,
        eranian@google.com, andi@firstfloor.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v4 9/9] tools, perf: Allow the user to disable time stamps
Message-ID: <20140731144548.GC20547@kernel.org>
References: <1406789104-25863-1-git-send-email-zheng.z.yan@intel.com>
 <1406789104-25863-10-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406789104-25863-10-git-send-email-zheng.z.yan@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 31, 2014 at 02:45:04PM +0800, Yan, Zheng escreveu:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Time stamps are always implicitely enabled for record currently.
> The old --time/-T option is a nop.

Thanks, applied.

- Arnaldo
