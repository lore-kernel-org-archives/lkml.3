Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab3KULJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:09:44 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:43422 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab3KULJm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:09:42 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Francois Bedard" <Francois.Bedard@synopsys.com>,
        Ingo Molnar <mingo@kernel.org>, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] ARC: Add guard macro to uapi/asm/unistd.h
Thread-Topic: [PATCH] ARC: Add guard macro to uapi/asm/unistd.h
Thread-Index: AQHO5qShMCQIah50h0OHpbd+whljfQ==
Date: Thu, 21 Nov 2013 11:09:34 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075156D0C@IN01WEMBXA.internal.synopsys.com>
References: <1385029778-26092-1-git-send-email-vgupta@synopsys.com>
 <528DE731.6040200@gmail.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.239.235]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2013 04:25 PM, Chen Gang wrote:
>> +
>> > +#endif
>> > 
> Is it better to append comment for "#endif"?
>
> e.g. "#endif /* _UAPI_ASM_ARC_UNISTD_H */"

It's a preference thing. I do it when there are multiple #endif's, hence need some
disambiguation.


