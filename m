Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab3L3Jyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 04:54:44 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60604 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752051Ab3L3Jyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 04:54:43 -0500
X-Sasl-enc: IpwxzOaK3g8ofHseRNHZkWRBe/VnBhfmW1+JjA5DEZ1Y 1388397282
Message-ID: <52C142E0.8010003@iki.fi>
Date: Mon, 30 Dec 2013 11:54:40 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>, Pekka Enberg <penberg@kernel.org>
CC: Li Zefan <lizefan@huawei.com>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/slub: fix accumulate per cpu partial cache objects
References: <1388137619-14741-1-git-send-email-liwanp@linux.vnet.ibm.com> <52BE2E74.1070107@huawei.com> <CAOJsxLFH5LGuF+vutPzB90EM9o376Jc99-rjY4qq18d1KQshhg@mail.gmail.com> <20131230010800.GA1623@hacker.(null)>
In-Reply-To: <20131230010800.GA1623@hacker.(null)>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2013 03:08 AM, Wanpeng Li wrote:
> Zefan's patch is good enough, mine doesn't need any more.

OK, thanks guys!

             Pekka
