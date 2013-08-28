Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab3H1EZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 00:25:08 -0400
Received: from us02smtp1.synopsys.com ([198.182.60.75]:52876 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab3H1EZF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 00:25:05 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Christoph Lameter <cl@linux.com>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>, Tejun Heo <tj@kernel.org>,
        "akpm@linuxfoundation.org" <akpm@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [guv v2 28/31] arc: Replace __get_cpu_var uses throughout the
 kernel
Thread-Topic: [guv v2 28/31] arc: Replace __get_cpu_var uses throughout the
 kernel
Thread-Index: AQHOoqcZ8J70BiHtxkiDsBTqyM9IJg==
Date: Wed, 28 Aug 2013 04:24:59 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075140D73@IN01WEMBXA.internal.synopsys.com>
References: <20130826204351.725357339@linux.com>
 <00000140bca09c39-5b837fed-8e34-417d-a62d-031f0b5c8107-000000@email.amazonses.com>
 <521C2A9F.3070400@synopsys.com>
 <00000140c05d28b7-f0a2bc86-fe85-40f7-b627-32664cd616a4-000000@email.amazonses.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.15.84.232]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2013 08:51 PM, Christoph Lameter wrote:
> On Tue, 27 Aug 2013, Vineet Gupta wrote:
>
>> The other thread about merging logistics doesn't seem to have concluded yet so for
>> now I'll let it sit with you - please let me know if it needs to be routed via the
>> arc tree.
> Please route via the arc tree. I will marge the last patch when all the
> bits are in.
>

Done - although it is missing you SOB line ?

-Vineet
