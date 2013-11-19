Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab3KSCWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 21:22:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41701 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab3KSCWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 21:22:50 -0500
Message-ID: <528ACB6A.1040809@zytor.com>
Date: Mon, 18 Nov 2013 18:22:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: =?UTF-8?B?Sm9oYW5uZXMgTMO2dGhiZXJn?= <johannes@kyriasis.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: boot: Fix mixed indentation in a20.c
References: <1384797009-4096-1-git-send-email-johannes@kyriasis.com>
In-Reply-To: <1384797009-4096-1-git-send-email-johannes@kyriasis.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 09:50 AM, Johannes Löthberg wrote:
> Replace all mixed indentation with tabs
> 
> Signed-off-by: Johannes Löthberg <johannes@kyriasis.com>

NAK.  Not worth the churn in the absence of other changes.

	-hpa


