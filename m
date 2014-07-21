Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529AbaGUOWC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:22:02 -0400
Received: from smtprelay.synopsys.com ([198.182.60.111]:38589 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423AbaGUOWA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:22:00 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Richard Weinberger <richard@sigma-star.at>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        "Vineet.Gupta1@synopsys.com" <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH 01/43] arc: Use get_signal() signal_setup_done()
Thread-Topic: [PATCH 01/43] arc: Use get_signal() signal_setup_done()
Thread-Index: AQHPpOyf+PHuRx8PyECET2q013zt2w==
Date: Mon, 21 Jul 2014 14:21:50 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230753C4B4C97@IN01WEMBXA.internal.synopsys.com>
References: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
 <1405951409-16953-2-git-send-email-richard@sigma-star.at>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.93]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 July 2014 07:34 PM, Richard Weinberger wrote:
> From: Richard Weinberger <richard@nod.at>
>
> Use the more generic functions get_signal() signal_setup_done()
> for signal delivery.
>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> Acked-by: Vineet Gupta <vgupta@synopsys.com>

Thx Richard.

Applied to arc for-next !

-Vineet
