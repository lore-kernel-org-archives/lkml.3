Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbaCCEcc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 23:32:32 -0500
Received: from us01smtprelay-2.synopsys.com ([198.182.44.111]:41457 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbaCCEcX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 23:32:23 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Richard Weinberger <richard@nod.at>
CC: lkml <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 29/44] arc: Use translate_signal()
Thread-Topic: [PATCH 29/44] arc: Use translate_signal()
Thread-Index: AQHPNnN8RonqNNVBkkKFaZ6f4rB+ig==
Date: Mon, 3 Mar 2014 04:32:13 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307517FA9F@IN01WEMBXA.internal.synopsys.com>
References: <1393804758-7916-1-git-send-email-richard@nod.at>
 <1393804758-7916-7-git-send-email-richard@nod.at>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.197.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

Thanks for this.

On Monday 03 March 2014 07:59 AM, Richard Weinberger wrote:
> Use the common helper instead of it's own variant.
>
> Signed-off-by: Richard Weinberger <richard@nod.at>

Acked-by: Vineet Gupta <vgupta@synopsys.com>    [arch/arc bits]

-Vineet
