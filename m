Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab3BUUGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 15:06:49 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:57470 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab3BUUGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 15:06:48 -0500
MIME-Version: 1.0
In-Reply-To: <1361471962-25164-3-git-send-email-vgupta@synopsys.com>
References: <1361471962-25164-1-git-send-email-vgupta@synopsys.com>
	<1361471962-25164-3-git-send-email-vgupta@synopsys.com>
Date: Thu, 21 Feb 2013 23:06:47 +0300
Message-ID: <CAMo8Bf+Rc3gazyN6zPxV-P5A67ERQPKovZSRO9WNdfN2o1jzNw@mail.gmail.com>
Subject: Re: [PATCH 2/2] xtensa: Flat DeviceTree copy not future-safe
From: Max Filippov <jcmvbkbc@gmail.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Zankel <chris@zankel.net>,
        Marc Gauthier <marc@tensilica.com>, linux-xtensa@linux-xtensa.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 10:39 PM, Vineet Gupta
<Vineet.Gupta1@synopsys.com> wrote:
> flat DT copy code calls bootmem allocator with @align = 0.
> This is probably OK with legacy allocator which xtensa uses right now,
> but this will panic right away with memblock allocator
>
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Cc: Chris Zankel <chris@zankel.net>
> Cc: Max Filippov <jcmvbkbc@gmail.com>
> Cc: Marc Gauthier <marc@tensilica.com>
> Cc: linux-xtensa@linux-xtensa.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Max Filippov <jcmvbkbc@gmail.com>

-- 
Thanks.
-- Max
