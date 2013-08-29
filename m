Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab3H2GZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 02:25:39 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:60359 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab3H2GZi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 02:25:38 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Mischa Jonker <Mischa.Jonker@synopsys.com>
CC: Gilad Ben-Yossef <gilad@benyossef.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARC: Add read*_relaxed to asm/io.h
Thread-Topic: [PATCH] ARC: Add read*_relaxed to asm/io.h
Thread-Index: AQHOpB0PPRo+2zYPs0OXZUZ+L/3fkQ==
Date: Thu, 29 Aug 2013 06:25:34 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075140F52@IN01WEMBXA.internal.synopsys.com>
References: <1377714770-2251-1-git-send-email-mjonker@synopsys.com>
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

On 08/29/2013 12:03 AM, Mischa Jonker wrote:
> Some drivers require these, and ARC didn't had them yet.
>
> Signed-off-by: Mischa Jonker <mjonker@synopsys.com>

Applied.

Thx,
-Vineet
