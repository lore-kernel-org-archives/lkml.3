Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbaKTUG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 15:06:59 -0500
Received: from resqmta-ch2-09v.sys.comcast.net ([69.252.207.41]:36472 "EHLO
	resqmta-ch2-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757959AbaKTUG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 15:06:57 -0500
Date: Thu, 20 Nov 2014 14:06:53 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
cc: Jerome Marchand <jmarchan@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Steve Capper <steve.capper@linaro.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 06/19] mm: store mapcount for compound page separate
In-Reply-To: <20141119130050.GA29884@node.dhcp.inet.fi>
Message-ID: <alpine.DEB.2.11.1411201405140.14867@gentwo.org>
References: <1415198994-15252-1-git-send-email-kirill.shutemov@linux.intel.com> <1415198994-15252-7-git-send-email-kirill.shutemov@linux.intel.com> <546C761D.6050407@redhat.com> <20141119130050.GA29884@node.dhcp.inet.fi>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014, Kirill A. Shutemov wrote:

> I don't think we want to bloat struct page description: nobody outside of
> helpers should use it direcly. And it's exactly what we did to store
> compound page destructor and compound page order.

This is more like a description what overloading is occurring. Either
add the new way of using it there including a comment explainng things or
please do not overload the field.

