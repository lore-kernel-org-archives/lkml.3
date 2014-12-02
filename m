Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933163AbaLBNal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 08:30:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932853AbaLBNaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 08:30:39 -0500
Message-ID: <547DBEF8.2070100@redhat.com>
Date: Tue, 02 Dec 2014 14:30:32 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: mad Engineer <themadengin33r@gmail.com>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Allocating dedicated RAM to host that guest can not use
References: <CAN8oO4BwKdK0AioN=r97NKB=RxrUNrn3822o9nrH466ras+aHA@mail.gmail.com>	<20141127112931.GA3282@kernel>	<CAN8oO4A+_WyvtitEG75tQR3otfEq6zoou+Ve-OjkEg59agFYVg@mail.gmail.com> <CAN8oO4Dc2EUtJkhULaV6CJ2RmF1aMXmNBEOwiMEbJ0mrt3ndNQ@mail.gmail.com>
In-Reply-To: <CAN8oO4Dc2EUtJkhULaV6CJ2RmF1aMXmNBEOwiMEbJ0mrt3ndNQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 27/11/2014 13:16, mad Engineer wrote:
> a random thought can we set qemu user/group rss to a particular hard
> limit in limits.conf

Those apply per process, not per user/group.

Paolo
