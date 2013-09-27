Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab3I0E7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 00:59:11 -0400
Received: from kiruna.synopsys.com ([198.182.44.80]:49531 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab3I0E7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 00:59:09 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Rob Herring <robherring2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Will Deacon" <will.deacon@arm.com>, Mark Salter <msalter@redhat.com>,
        "Aurelien Jacquiot" <a-jacquiot@ti.com>,
        James Hogan <james.hogan@imgtec.com>,
        "Jonas Bonn" <jonas@southpole.se>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [PATCH 21/21] of: remove empty arch prom.h headers
Thread-Topic: [PATCH 21/21] of: remove empty arch prom.h headers
Thread-Index: AQHOuuly6hcIllAWOUKM+0ii6kOgGQ==
Date: Fri, 27 Sep 2013 04:59:03 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307514EABB@IN01WEMBXA.internal.synopsys.com>
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
 <1380221456-11192-22-git-send-email-robherring2@gmail.com>
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

On 09/27/2013 12:21 AM, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>
> Now that prom.h is optional, all the empty prom.h headers can be removed.
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>

Acked-by: Vineet Gupta <vgupta@synopsys.com>

Thx for the continued cleanup.
-Vineet

