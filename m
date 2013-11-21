Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab3KUNBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 08:01:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:38409 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab3KUNBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 08:01:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,744,1378882800"; 
   d="scan'208";a="431470710"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
In-Reply-To: <1385038007-29666-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1385038007-29666-1-git-send-email-kirill.shutemov@linux.intel.com>
Subject: RE: [PATCH] x86, mm: do not leak page->ptl for pmd page tables
Content-Transfer-Encoding: 7bit
Message-Id: <20131121130006.E5A41E0090@blue.fi.intel.com>
Date: Thu, 21 Nov 2013 15:00:06 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please, ignore. Sent wrong patch.

-- 
 Kirill A. Shutemov
