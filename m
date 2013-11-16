Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab3KPUTd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 15:19:33 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:59720 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3KPUT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 15:19:26 -0500
Message-ID: <5287D34B.8010600@linux.com>
Date: Sat, 16 Nov 2013 21:19:23 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>,
        linux-kernel@vger.kernel.org
CC: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] kstrtox: remove redundant cleanup
References: <1384623151-31302-1-git-send-email-felipe.contreras@gmail.com> <1384623151-31302-2-git-send-email-felipe.contreras@gmail.com>
In-Reply-To: <1384623151-31302-2-git-send-email-felipe.contreras@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-11-16 18:32 keltezéssel, Felipe Contreras írta:
> We can't reach the cleanup code unless the flag KSTRTOX_OVERFLOW is not
> set, so there's not no point in clearing a bit that we know is not set.
> 
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
Acked-by: Levente Kurusa <levex@linux.com>

Legit one. To be honest, I don't know who will apply it, because of the stuff discussed
earlier.

-- 
Regards,
Levente Kurusa
