Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbbAWK6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:58:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbbAWK6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:58:15 -0500
Message-ID: <54C22938.3070709@redhat.com>
Date: Fri, 23 Jan 2015 11:58:00 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] samples: bpf: relax test_maps check
References: <1421975469-13035-1-git-send-email-ast@plumgrid.com> <1421975469-13035-3-git-send-email-ast@plumgrid.com>
In-Reply-To: <1421975469-13035-3-git-send-email-ast@plumgrid.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 02:11 AM, Alexei Starovoitov wrote:
> hash map is unordered, so get_next_key() iterator shouldn't
> rely on particular order of elements. So relax this test.
>
> Fixes: ffb65f27a155 ("bpf: add a testsuite for eBPF maps")
> Reported-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>

Acked-by: Daniel Borkmann <dborkman@redhat.com>
