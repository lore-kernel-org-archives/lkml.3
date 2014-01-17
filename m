Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbaAQO6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:58:24 -0500
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:51456 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752271AbaAQO6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:58:20 -0500
Date: Fri, 17 Jan 2014 08:58:17 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Dave Hansen <dave@sr71.net>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, penberg@kernel.org
Subject: Re: [RFC][PATCH 5/9] mm: rearrange struct page
In-Reply-To: <52D85D33.4080509@sr71.net>
Message-ID: <alpine.DEB.2.10.1401170857230.1943@nuc>
References: <20140114180042.C1C33F78@viggo.jf.intel.com> <20140114180055.21691733@viggo.jf.intel.com> <alpine.DEB.2.10.1401161233060.30036@nuc> <52D85D33.4080509@sr71.net>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014, Dave Hansen wrote:

> Why does it matter *specifically* that "index shares space with
> freelist", or that "mapping shares space with s_mem"?  No data is ever
> handed off in those fields.

If the field is corrupted then one needs to figure out what other ways of
using this field exists. If one wants to change the page struct fields
then also knowlege about possible interconnections are important.

