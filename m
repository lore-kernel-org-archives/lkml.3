Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab3IEOaC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 10:30:02 -0400
Received: from us01smtp2.synopsys.com ([198.182.44.80]:56109 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab3IEO36 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 10:29:58 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Christoph Lameter <cl@linux.com>
CC: Tejun Heo <tj@kernel.org>,
        "akpm@linuxfoundation.org" <akpm@linuxfoundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [gcv v3 32/35] arc: Replace __get_cpu_var uses
Thread-Topic: [gcv v3 32/35] arc: Replace __get_cpu_var uses
Thread-Index: AQHOqkL4N77MrQoWIkmairib25dNBw==
Date: Thu, 5 Sep 2013 14:29:49 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075141CCD@IN01WEMBXA.internal.synopsys.com>
References: <20130828193457.140443630@linux.com>
 <00000140c6781cab-d0df0392-b65b-4213-8be0-1e4a04f67fb2-000000@email.amazonses.com>
 <C2D7FE5348E1B147BCA15975FBA23075140F60@IN01WEMBXA.internal.synopsys.com>
 <00000140caf51d3b-0c5ebca6-f4a7-49b8-94c8-fc8b0bde04b8-000000@email.amazonses.com>
 <5226E55A.3000705@synopsys.com>
 <00000140e952bc1f-25743208-6728-4ded-b110-9ded0321f723-000000@email.amazonses.com>
 <52281024.20309@synopsys.com>
 <00000140ee7e1cf2-bfccaa36-5c54-4513-b7a8-cfa67a476dd7-000000@email.amazonses.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.239.237]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 07:49 PM, Christoph Lameter wrote:
> On Thu, 5 Sep 2013, Vineet Gupta wrote:
>
>> Yes I do see the macro fix in mainline but no discussions related to missing
>> preemption debug checks after NAK from Peter/Ingo.
> v4 was posted yesterday with the preemption bug checks.

I see that. IMHO it would be better if all of this gets merged into mainline in
one cycle.
I'm a relatively new maintainer so I'm not sure how to handle this. Andrew, Tejun,
Steven what say you ?

-Vineet
