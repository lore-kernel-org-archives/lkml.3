Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbaAUXsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 18:48:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41422 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbaAUXsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 18:48:14 -0500
Message-ID: <1390348085.5027.18.camel@smoke>
Subject: Re: [PATCH 10/73] powerpc: use device_initcall for registering rtc
 devices
From: Geoff Levand <geoff@infradead.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Date: Tue, 21 Jan 2014 15:48:05 -0800
In-Reply-To: <1390339396-3479-11-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
	 <1390339396-3479-11-git-send-email-paul.gortmaker@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Tue, 2014-01-21 at 16:22 -0500, Paul Gortmaker wrote:
> Currently these two RTC devices are in core platform code
> where it is not possible for them to be modular.  It will
> never be modular, so using module_init as an alias for
> __initcall can be somewhat misleading.
> 
>  arch/powerpc/kernel/time.c        | 2 +-
>  arch/powerpc/platforms/ps3/time.c | 3 +--
>  2 files changed, 2 insertions(+), 3 deletions(-)

I tested the PS3 part of this patch and it seems to work OK.

Acked-by: Geoff Levand <geoff@infradead.org>

