Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab3ARW5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 17:57:19 -0500
Received: from mga03.intel.com ([143.182.124.21]:37667 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274Ab3ARW5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 17:57:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,495,1355126400"; 
   d="scan'208";a="245792682"
Date: Fri, 18 Jan 2013 14:57:15 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, jolsa@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v6 02/18] perf/x86: improve sysfs event mapping with
 event string
Message-ID: <20130118225715.GG4051@tassilo.jf.intel.com>
References: <1358264386-24633-1-git-send-email-eranian@google.com>
 <1358264386-24633-3-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358264386-24633-3-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 04:39:30PM +0100, Stephane Eranian wrote:
> This patch extends Jiri's changes to make generic
> events mapping visible via sysfs. The patch extends
> the mechanism to non-generic events by allowing
> the mappings to be hardcoded in strings.
> 
> This mechanism will be used by the PEBS-LL patch
> later on.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

Looks good to me.

Acked-by: Andi Kleen <ak@linux.intel.com>
