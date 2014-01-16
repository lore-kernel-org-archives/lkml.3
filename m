Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaAPSfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:35:05 -0500
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:48830 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750937AbaAPSfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:35:02 -0500
Date: Thu, 16 Jan 2014 12:34:59 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Dave Hansen <dave@sr71.net>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, penberg@kernel.org
Subject: Re: [RFC][PATCH 5/9] mm: rearrange struct page
In-Reply-To: <20140114180055.21691733@viggo.jf.intel.com>
Message-ID: <alpine.DEB.2.10.1401161233060.30036@nuc>
References: <20140114180042.C1C33F78@viggo.jf.intel.com> <20140114180055.21691733@viggo.jf.intel.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014, Dave Hansen wrote:

>
> This makes it *MUCH* more clear how the first few fields of
> 'struct page' get used by the slab allocators.

I think this adds to the confusion. What you want to know is which other
fields overlap a certain field. After this patch you wont have that
anymore.
