Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761709Ab3DDO2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:28:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:47002 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760186Ab3DDO2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:28:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,409,1363158000"; 
   d="scan'208";a="280782595"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Mel Gorman <mgorman@suse.de>,
        Dave Jones <davej@redhat.com>, linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <515D882E.6040001@oracle.com>
References: <51559150.3040407@oracle.com>
 <515D882E.6040001@oracle.com>
Subject: Re: mm: BUG in do_huge_pmd_wp_page
Content-Transfer-Encoding: 7bit
Message-Id: <20130404143048.02672E0085@blue.fi.intel.com>
Date: Thu,  4 Apr 2013 17:30:47 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin wrote:
> Ping? I'm seeing a whole bunch of these with current -next.

Do you have a way to reproduce?

-- 
 Kirill A. Shutemov
