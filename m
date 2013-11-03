Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab3KCGdh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 01:33:37 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:36470 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab3KCGdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 01:33:35 -0500
Message-ID: <5275EE14.2000701@oracle.com>
Date: Sun, 03 Nov 2013 14:32:52 +0800
From: Vaughan Cao <vaughan.cao@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: dgilbert@interlog.com, Christoph Hellwig <hch@infradead.org>
CC: SCSI development list <linux-scsi@vger.kernel.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
Subject: Re: [PATCH v2] sg: O_EXCL and other lock handling
References: <52718713.7050906@interlog.com> <20131031155653.GA16944@infradead.org> <5272AD80.90203@interlog.com> <5273391C.2010705@oracle.com> <527542E3.7090809@interlog.com>
In-Reply-To: <527542E3.7090809@interlog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2013年11月03日 02:22, Douglas Gilbert wrote:
> On 13-11-01 01:16 AM, vaughan wrote:
>
> I do not follow the last point but that is not important.
>
>
> For reasons that I listed in a private post I think
> that my patch presented in this thread is closer to
> our goals than your patch (2013/6/17/319). Timing is
> important as well since we are approaching the lk 3.13
> merge window. Regressions are what will set us back.
>
Yes, I agree with you. My v2 patch lacks much consideration on 
release/detach cases, which is a very significant issue we should 
address along with o_excl bug.

Thanks,
Vaughan
