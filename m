Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490Ab3JORbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:31:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40240 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932950Ab3JORbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:31:40 -0400
Message-ID: <525D7BDE.4070400@zytor.com>
Date: Tue, 15 Oct 2013 10:31:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Toshi Kani <toshi.kani@hp.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH part2 v2 0/8] Arrange hotpluggable memory as ZONE_MOVABLE
References: <20131014142719.GI4722@htj.dyndns.org> <525C02DC.4050706@gmail.com> <20131014145131.GJ4722@htj.dyndns.org> <525C0866.2010808@gmail.com> <20131014151902.GL4722@htj.dyndns.org> <525C0EFE.2010409@gmail.com> <CAE9FiQX0xeR61ehPy2SfWfN-fgSZVS=dtaWT-QQ+RR12tx+A0w@mail.gmail.com> <20131014200437.GA5720@htj.dyndns.org> <CAE9FiQXCG6gR-XL9fVudpNVEdS-3MHPObfWQ=Uf=q7pv33QBOA@mail.gmail.com> <525C5727.7000603@zytor.com> <20131015065040.GB24584@gmail.com>
In-Reply-To: <20131015065040.GB24584@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 11:50 PM, Ingo Molnar wrote:
> 
> So if anyone can implement it using huge pages, with a really fast __va() 
> and __pa() implementation, then it might be possible. But that's a pretty 
> major surgery on x86.
> 

Well, we already *have* a way to deal with that for Xen (by inserting an
otherwise nonexistent logical level.)  I'm wondering if those interfaces
could be (ab)used for this as well, or if that is functionally
equivalent to saying that this should be done in a hypervisor.

	-hpa


