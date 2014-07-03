Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbaGCPDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:03:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758279AbaGCPD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:03:29 -0400
Message-ID: <53B570BA.7080703@redhat.com>
Date: Thu, 03 Jul 2014 17:03:22 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Zi Shen Lim <zlim.lnx@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@plumgrid.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 net-next] net: filter: move load_pointer() into filter.h
References: <1404399414-32099-1-git-send-email-zlim.lnx@gmail.com>
In-Reply-To: <1404399414-32099-1-git-send-email-zlim.lnx@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2014 04:56 PM, Zi Shen Lim wrote:
> load_pointer() is already a static inline function.
> Let's move it into filter.h so BPF JIT implementations can reuse this
> function.
>
> Since we're exporting this function, let's also rename it to
> bpf_load_pointer() for clarity.
>
> Signed-off-by: Zi Shen Lim <zlim.lnx@gmail.com>

Reviewed-by: Daniel Borkmann <dborkman@redhat.com>
