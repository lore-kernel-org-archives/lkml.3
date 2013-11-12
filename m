Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab3KLOvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:51:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755803Ab3KLOvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:51:11 -0500
Message-ID: <1384267842.24631.3.camel@deneb.redhat.com>
Subject: Re: [PATCH 03/11] arm: use generic fixmap.h
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 12 Nov 2013 09:50:42 -0500
In-Reply-To: <1384262545-20875-4-git-send-email-msalter@redhat.com>
References: <1384262545-20875-1-git-send-email-msalter@redhat.com>
	 <1384262545-20875-4-git-send-email-msalter@redhat.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-12 at 08:22 -0500, Mark Salter wrote:
> Signed-off-by: Mark Salter <msalter@redhat.com>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: linux-arm-kernel@lists.infradead.org
> ---
>  arch/arm/include/asm/fixmap.h | 25 ++++++-------------------
>  1 file changed, 6 insertions(+), 19 deletions(-)

Okay, this one is wrong. I just noticed that arm is different
from other architectures in that increasing fixed indices
convert to increasing virt addresses. Does this need to be
the case or is it okay to change it to match other architectures?

--Mark


