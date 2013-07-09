Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab3GIUnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 16:43:22 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:42124 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab3GIUnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 16:43:19 -0400
MIME-Version: 1.0
In-Reply-To: <1373389983.14604.18.camel@joe-AO722>
References: <1373384438.4391.6.camel@chaos.site>
	<1373384574.4391.9.camel@chaos.site>
	<1373386794.14604.14.camel@joe-AO722>
	<1373389983.14604.18.camel@joe-AO722>
Date: Tue, 9 Jul 2013 13:43:17 -0700
Message-ID: <CA+8MBbJmm1ehU1dKUM2YYy-gBG5n6hGt6-vjyvE=9COa+ZSt=A@mail.gmail.com>
Subject: Re: ia64: dmi.h: Make dmi_alloc use kzalloc
From: Tony Luck <tony.luck@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Jean Delvare <jdelvare@suse.de>, linux-kernel@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64 <linux-ia64@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 9, 2013 at 10:13 AM, Joe Perches <joe@perches.com> wrote:
> x86/ia64 have a slight mismatch in dmi_alloc as
> x86 does a memset(0), and ia64 just does kmalloc.
>
> Make the ia64 dmi_alloc match the x86 style.
>
> Signed-off-by: Joe Perches <joe@perches.com>

Applied. Thanks Joe.

-Tony
