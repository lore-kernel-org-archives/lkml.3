Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbaIERfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:35:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100AbaIERfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:35:05 -0400
Message-ID: <5409F43B.1050900@redhat.com>
Date: Fri, 05 Sep 2014 19:34:51 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
CC: Mikulas Patocka <mpatocka@redhat.com>,
        Hannes Frederic Sowa <hannes@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH] bpf: fix a false positive kmemcheck warning
References: <alpine.LRH.2.02.1409051157440.5269@file01.intranet.prod.int.rdu2.redhat.com> <5409E2C8.2080200@redhat.com> <1409936457.5306.2.camel@localhost> <5409EE70.9020304@redhat.com> <alpine.LRH.2.02.1409051313350.5269@file01.intranet.prod.int.rdu2.redhat.com> <5409F032.50101@redhat.com> <CAMEtUuyX8Oak48vS+EDLmHY6p0yjrYNr9YXLNEYJsS7HsuooRg@mail.gmail.com>
In-Reply-To: <CAMEtUuyX8Oak48vS+EDLmHY6p0yjrYNr9YXLNEYJsS7HsuooRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 07:21 PM, Alexei Starovoitov wrote:
...
> imo it's cleaner to convert to bool unconditionally instead
> of annotating things everywhere.

Will do, fine as well.
