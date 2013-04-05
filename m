Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162139Ab3DERPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 13:15:12 -0400
Received: from r00tworld.com ([212.85.137.150]:35160 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162066Ab3DERPL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 13:15:11 -0400
From: "PaX Team" <pageexec@freemail.hu>
To: trivial@kernel.org, linux-kernel@vger.kernel.org,
        "=?UTF-8?Q?Jan-Simon_M=C3=B6ller?=" <jsmoeller.linux@gmail.com>
Date: Fri, 05 Apr 2013 19:08:34 +0200
MIME-Version: 1.0
Subject: Re: [PATCH] [TRIVIAL] FIX: unintended variable name reuse
Reply-to: pageexec@freemail.hu
Message-ID: <515F0512.4124.1F11126A@pageexec.freemail.hu>
In-reply-to: <2178091.aRcfQYZIWb@aragorn.auenland.lan>
References: <2178091.aRcfQYZIWb@aragorn.auenland.lan>
X-mailer: Pegasus Mail for Windows (4.63)
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Fri, 05 Apr 2013 19:08:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 Apr 2013 at 18:17, Jan-Simon Möller wrote:

> Cleanup a variable name reuse. 
> 
> 
> Fix suggested by PaX Team <pageexec@freemail.hu>

Reviewed-by: PaX Team <pageexec@freemail.hu>

> Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_uncore.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)

