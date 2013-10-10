Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab3JJFFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 01:05:42 -0400
Received: from kiruna.synopsys.com ([198.182.44.80]:33072 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab3JJFFk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 01:05:40 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Rob Herring <robherring2@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        "Rob Herring" <rob.herring@calxeda.com>
Subject: Re: [PATCH v2 25/29] arc: use common of_flat_dt_match_machine
Thread-Topic: [PATCH v2 25/29] arc: use common of_flat_dt_match_machine
Thread-Index: AQHOxRGx68QrL9yDyUuM7i3lErUOEw==
Date: Thu, 10 Oct 2013 05:04:13 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075150EC9@IN01WEMBXA.internal.synopsys.com>
References: <1381163377-21044-1-git-send-email-robherring2@gmail.com>
	<1381163377-21044-26-git-send-email-robherring2@gmail.com>
	<52539B4C.9040400@synopsys.com>
 <CAL_JsqJS8Vwt2363BXP+3zVNAHM-H=JPKEMkaq22wuQJBCZUXw@mail.gmail.com>
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

On 10/09/2013 10:35 PM, Rob Herring wrote:
> Thanks. I've added this in and updated my branch. Please double check
> it when you have a chance. I also made __arch_info_begin[] and
> __arch_info_end[] const.

Works great !

Thx,
-Vineet
