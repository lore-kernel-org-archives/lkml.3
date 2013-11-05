Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab3KEPgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 10:36:18 -0500
Received: from mail.southpole.se ([37.247.8.11]:59737 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab3KEPgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 10:36:17 -0500
X-Greylist: delayed 1117 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Nov 2013 10:36:17 EST
Message-ID: <52790C37.1010802@southpole.se>
Date: Tue, 05 Nov 2013 16:18:15 +0100
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux@openrisc.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] openrisc: Refactor 16-bit constant relocation
References: <1382711876-21439-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1382711876-21439-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.3.3(13276) on assp.southpole.se
X-Assp-ID: assp.southpole.se 64652-12458
X-Assp-Session: 7F73985CCC48 (mail 1)
X-Assp-Client-TLS: yes
X-Assp-Server-TLS: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2013 04:37 PM, Geert Uytterhoeven wrote:
> arch/openrisc/kernel/module.c: In function 'apply_relocate_add':
> arch/openrisc/kernel/module.c:50:13: warning: assignment from incompatible pointer type
> arch/openrisc/kernel/module.c:54:13: warning: assignment from incompatible pointer type
>
> Move the pointer increments to the dereference statements to avoid
> incompatible pointer assignments, and remove superfluous casts.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Thanks, Geert.  Will apply.

/Jonas
