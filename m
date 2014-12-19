Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaLSIGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 03:06:03 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:33022 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbaLSIGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 03:06:01 -0500
Date: Fri, 19 Dec 2014 11:05:57 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Latest kernel build problem in arch/x86/ia32/audit.c
Message-ID: <20141219080557.GP9435@moon>
References: <20141218190409.GN9435@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141218190409.GN9435@moon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 10:04:09PM +0300, Cyrill Gorcunov wrote:
>   case __NR_execveat:
>        ^
> arch/x86/ia32/audit.c:38:7: note: each undeclared identifier is reported only once for each function it appears in
> make[2]: *** [arch/x86/ia32/audit.o] Error 1
> make[1]: *** [arch/x86/ia32] Error 2
> make: *** [arch/x86] Error 2
> make: *** Waiting for unfinished jobs....

Looks like it was leftover from old builds. mrproper fixed it.
Sorry for noise.
