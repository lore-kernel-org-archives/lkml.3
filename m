Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab3IQF1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 01:27:09 -0400
Received: from kiruna.synopsys.com ([198.182.44.80]:40451 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3IQF1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 01:27:07 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Rob Herring <robherring2@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 04/28] arc: use unflatten_and_copy_device_tree
Thread-Topic: [PATCH 04/28] arc: use unflatten_and_copy_device_tree
Thread-Index: AQHOszHTUXclc4mhKkiFNNyspsdkAw==
Date: Tue, 17 Sep 2013 05:27:01 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307514C261@IN01WEMBXA.internal.synopsys.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
 <1379372965-22359-5-git-send-email-robherring2@gmail.com>
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

On 09/17/2013 04:39 AM, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>
> Use the common unflatten_and_copy_device_tree to copy the built-in FDT
> out of init section.
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Vineet Gupta <vgupta@synopsys.com>

I tested the series - works great !

Acked by: Vineet Gupta <vgupta@synopsys.com>

Thx,
-Vineet
