Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab3KFViN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 16:38:13 -0500
Received: from a9-70.smtp-out.amazonses.com ([54.240.9.70]:46119 "EHLO
	a9-70.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754524Ab3KFViM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:38:12 -0500
Date: Wed, 6 Nov 2013 21:38:10 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Andreas Herrmann <andreas.herrmann@calxeda.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/slub: Switch slub_debug kernel option to early_param
 to avoid boot panic
In-Reply-To: <20131106211604.GM5661@alberich>
Message-ID: <000001422f59e79e-ba0d30e2-fe7d-4e6f-9029-65dc5978fe60-000000@email.amazonses.com>
References: <20131106184529.GB5661@alberich> <000001422ed8406b-14bef091-eee0-4e0e-bcdd-a8909c605910-000000@email.amazonses.com> <20131106195417.GK5661@alberich> <20131106203429.GL5661@alberich> <20131106211604.GM5661@alberich>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.11.06-54.240.9.70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013, Andreas Herrmann wrote:

> Would be nice, if your patch is pushed upstream asap.

Ok so this is a

Tested-by: Andreas Herrmann <andreas.herrmann@calxeda.com>

I think?

BTW Calxeda is a great product. Hope you get 64 bit running soon.

