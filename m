Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbaFRUi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:38:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767AbaFRUi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:38:56 -0400
Message-ID: <53A1F8D9.7070704@redhat.com>
Date: Wed, 18 Jun 2014 22:38:49 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Jet Chen <jet.chen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, lkp@01.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [net] b58537a1f56: +89.2% netperf.Throughput_Mbps
References: <53A10291.7090301@intel.com> <alpine.DEB.2.02.1406181328160.10339@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1406181328160.10339@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 10:29 PM, David Rientjes wrote:
> On Wed, 18 Jun 2014, Jet Chen wrote:
>
>> Hi Daniel,
>>
>> FYI, we noticed the below changes on
>>
>> commit b58537a1f5629bdc98a8b9dc2051ce0e952f6b4b ("net: sctp: fix permissions
>> for rto_alpha and rto_beta knobs")
>
> There's no way this is legitimate, that commit cannot possibly affect the
> performance of netperf.  I wouldn't bother to spend any time investigating
> this.

One assumption could be that netperf was setting this knob
internally and ignoring the result of it (error/success), but
that we might need to look up in netperf source to confirm.

Cheers,

Daniel
