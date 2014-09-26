Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbaIZCYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 22:24:53 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:35201 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbaIZCYu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 22:24:50 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Guenter Roeck <linux@roeck-us.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: New build failures in Sep 25 tree
Thread-Topic: linux-next: New build failures in Sep 25 tree
Thread-Index: AQHP2P7y21uM6YAzbUeUiLv+2yP6BA==
Date: Fri, 26 Sep 2014 02:23:19 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230753C5DECF4@IN01WEMBXA.internal.synopsys.com>
References: <20140925202559.GA1750@roeck-us.net>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.182]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 26 September 2014 01:56 AM, Guenter Roeck wrote:
> arc:defconfig
>
> arch/arc/kernel/setup.c: In function 'customize_machine':
> arch/arc/kernel/setup.c:354: error: implicit declaration of function 'of_clk_init'

This is now fixed/pushed.

Thx,
-Vineet
