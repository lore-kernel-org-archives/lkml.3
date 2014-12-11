Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933383AbaLKPDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 10:03:38 -0500
Received: from resqmta-ch2-01v.sys.comcast.net ([69.252.207.33]:56121 "EHLO
	resqmta-ch2-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932200AbaLKPDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 10:03:35 -0500
Date: Thu, 11 Dec 2014 09:03:33 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
cc: akpm@linux-foundation.org, jmarchan@redhat.com,
        aneesh.kumar@linux.vnet.ibm.com, dave.hansen@intel.com,
        aarcange@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: add fields for compound destructor and order into
 struct page
In-Reply-To: <1418304027-154173-1-git-send-email-kirill.shutemov@linux.intel.com>
Message-ID: <alpine.DEB.2.11.1412110902170.28416@gentwo.org>
References: <1418304027-154173-1-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2014, Kirill A. Shutemov wrote:

> Currently, we use lru.next/lru.prev plus cast to access or set
> destructor and order of compound page.

Acked-by: Christoph Lameter <cl@linux.com>
