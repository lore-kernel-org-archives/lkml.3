Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab3J3ImV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 04:42:21 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:47234 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752576Ab3J3ImS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 04:42:18 -0400
X-Sasl-enc: 6JKlPHrPVtyRzbNmxZeWVtPHBvamvcQOS6QasnwETWB7 1383122536
Message-ID: <5270C666.6090209@iki.fi>
Date: Wed, 30 Oct 2013 10:42:14 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Pekka Enberg <penberg@kernel.org>
CC: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 13/15] slab: use struct page for slab management
References: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com> <1381913052-23875-14-git-send-email-iamjoonsoo.kim@lge.com> <20131030082800.GA5753@lge.com>
In-Reply-To: <20131030082800.GA5753@lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2013 10:28 AM, Joonsoo Kim wrote:
> If you want an incremental patch against original patchset,
> I can do it. Please let me know what you want.

Yes, please. Incremental is much easier to deal with if we want this to 
end up in v3.13.

                     Pekka
