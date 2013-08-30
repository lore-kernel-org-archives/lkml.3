Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab3H3GVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 02:21:46 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:38723 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab3H3GVp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 02:21:45 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Mischa Jonker <Mischa.Jonker@synopsys.com>
CC: Arnd Bergmann <arnd@arndb.de>, Sachin Kamat <sachin.kamat@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARC: remove console_verbose() from setup_arch()
Thread-Topic: [PATCH] ARC: remove console_verbose() from setup_arch()
Thread-Index: AQHOpB3O0vpLDvHfIEy3J06+GwpyFw==
Date: Fri, 30 Aug 2013 06:21:41 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307514117F@IN01WEMBXA.internal.synopsys.com>
References: <1377715098-2347-1-git-send-email-mjonker@synopsys.com>
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

On 08/29/2013 12:08 AM, Mischa Jonker wrote:
> It prevents kernel parameters such as 'loglevel' from doing their job.
>
> Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
>

Applied for 3.12

Thx,
-Vineet
