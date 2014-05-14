Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaENTg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:36:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbaENTg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:36:26 -0400
Message-ID: <1400096138.21547.117.camel@deneb.redhat.com>
Subject: Re: [PATCH 08/27] c6x: Use generic tlb.h
From: Mark Salter <msalter@redhat.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-arch@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org,
        Aurelien Jacquiot <a-jacquiot@ti.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-c6x-dev@linux-c6x.org
Date: Wed, 14 May 2014 15:35:38 -0400
In-Reply-To: <1400093999-18703-9-git-send-email-richard@nod.at>
References: <1400093999-18703-1-git-send-email-richard@nod.at>
	 <1400093999-18703-9-git-send-email-richard@nod.at>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-14 at 20:59 +0200, Richard Weinberger wrote:
> As everything we need is now in generic tlb.h
> we can drop our own one.
> 
> Cc: Mark Salter <msalter@redhat.com>
> Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Tim Chen <tim.c.chen@linux.intel.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Richard Weinberger <richard@nod.at>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: linux-c6x-dev@linux-c6x.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Richard Weinberger <richard@nod.at>

Acked-by: Mark Salter <msalter@redhat.com>


