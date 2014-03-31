Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaCaXxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 19:53:44 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34581 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751138AbaCaXxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 19:53:39 -0400
X-Sasl-enc: xdShkZp4GKaN4GCo3fenYprpU1jQSS2MX1qQ+EpUcG6A 1396310011
Date: Mon, 31 Mar 2014 16:55:50 -0700
From: Greg KH <greg@kroah.com>
To: David Rientjes <rientjes@google.com>
Cc: stable@vger.kernel.org, Holger Kiehl <Holger.Kiehl@dwd.de>,
        Christoph Lameter <cl@linux.com>, Rafael Aquini <aquini@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch stable-3.13] mm: close PageTail race
Message-ID: <20140331235550.GC20979@kroah.com>
References: <alpine.DEB.2.02.1403281333290.18841@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1403281335200.18841@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403281335200.18841@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 01:35:37PM -0700, David Rientjes wrote:
> commit 668f9abbd4334e6c29fa8acd71635c4f9101caa7 upstream.

Applied, thanks.

greg k-h
