Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936184Ab3DJUoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 16:44:07 -0400
Received: from a9-66.smtp-out.amazonses.com ([54.240.9.66]:33809 "EHLO
	a9-66.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752105Ab3DJUoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 16:44:06 -0400
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Apr 2013 16:44:06 EDT
Date: Wed, 10 Apr 2013 20:38:19 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm: Rewrite the comment over migrate_pages() more
 comprehensibly
In-Reply-To: <20130410195919.17355.23052.stgit@srivatsabhat.in.ibm.com>
Message-ID: <0000013df5aba30b-b322bac3-7d1b-481d-bedc-33c3666fc627-000000@email.amazonses.com>
References: <20130410195919.17355.23052.stgit@srivatsabhat.in.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.04.10-54.240.9.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Apr 2013, Srivatsa S. Bhat wrote:

> The comment over migrate_pages() looks quite weird, and makes it hard
> to grasp what it is trying to say. Rewrite it more comprehensibly.

Acked-by: Christoph Lameter <cl@linux.com>
