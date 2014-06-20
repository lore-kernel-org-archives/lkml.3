Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966166AbaFTJkE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 05:40:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51636 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964927AbaFTJkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 05:40:01 -0400
Message-ID: <53A4016E.9040108@suse.cz>
Date: Fri, 20 Jun 2014 11:39:58 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Kamal Mostafa <kamal@canonical.com>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Makefile: version.h macros KERNEL_EXTRAVERSION, LINUX_EXTRAVERSION_CODE
References: <1403189058-24103-1-git-send-email-kamal@canonical.com>
In-Reply-To: <1403189058-24103-1-git-send-email-kamal@canonical.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 19.6.2014 16:44, Kamal Mostafa napsal(a):
> Adds new macro KERNEL_EXTRAVERSION(a,b,c,d) and value
> LINUX_EXTRAVERSION_CODE to version.h, allowing ranged version checks of
> extended-stable versions that use a numeric EXTRAVERSION value.
> 
> The new KERNEL_EXTRAVERSION(a,b,c,d) works like KERNEL_VERSION(a,b,c)...
> If EXTRAVERSION is set to ".{integer}" (the common extended-stable kernel
> version number scheme) then {integer} corresponds to KERNEL_EXTRAVERSION's
> fourth arg.  If EXTRAVERSION is blank or a non-".{integer}" string like
> "-rc5", that corresponds to a fourth parameter of 0.

Why don't you guys simply increment the third digit in the extended
stable tree and get support for KERNEL_VERSION() for free? You always
start after the respective stable branch has reached EOL, don't you?

Thanks,
Michal
