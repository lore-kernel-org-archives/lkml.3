Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaETKcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 06:32:17 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:28487 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaETKcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 06:32:15 -0400
X-IronPort-AV: E=Sophos;i="4.98,873,1392163200"; 
   d="scan'208";a="132841324"
Message-ID: <537B2F2C.4080905@citrix.com>
Date: Tue, 20 May 2014 12:32:12 +0200
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Vitaly Kuznetsov <vkuznets@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <felipe.franciosi@citrix.com>, <jerry.snitselaar@oracle.com>,
        <axboe@kernel.dk>
Subject: Re: [Xen-devel] Backport request to stable of two performance related
 fixes for xen-blkfront (3.13 fixes to earlier trees)
References: <20140514191122.GA7659@phenom.dumpdata.com>	<8738g44wxp.fsf@vitty.brq.redhat.com> <87ppj8zsfb.fsf@vitty.brq.redhat.com>
In-Reply-To: <87ppj8zsfb.fsf@vitty.brq.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/05/14 11:54, Vitaly Kuznetsov wrote:
> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
> 
>> 1) ramdisks (/dev/ram*) (persistent grants and indirect descriptors
>> disabled)
> 
> sorry, there was a typo. persistent grants and indirect descriptors are
> enabled with ramdisks, otherwise such testing won't make any sense.

I'm not sure how is that possible, from your description I get that you
are using 3.11 on the Dom0, which means blkback has support for
persistent grants and indirect descriptors, but the guest is RHEL7,
that's using the 3.10 kernel AFAICT, and this kernel only has persistent
grants implemented.

Roger.
