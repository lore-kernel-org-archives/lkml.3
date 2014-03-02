Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbaCBU7q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 15:59:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45765 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbaCBU7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 15:59:45 -0500
Message-ID: <53139BA3.5050701@zytor.com>
Date: Sun, 02 Mar 2014 12:59:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>,
        Chris Bainbridge <chris.bainbridge@gmail.com>
CC: Dennis Mungai <dmngaie@gmail.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Dave Jones <davej@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set Pentium M as PAE capable
References: <20140302205619.GA8676@rhlx01.hs-esslingen.de>
In-Reply-To: <20140302205619.GA8676@rhlx01.hs-esslingen.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2014 12:56 PM, Andreas Mohr wrote:
> 
> (BTW, would it be possible to transform Linux's PAE support into
> boot-config or even fully runtime-detectable boot switching to
> (non-)PAE, similar to or exceeding what XP offers with its static
> boot-time flag?
> Last time I checked PAE support config defines were spread over ~ 40
> kernel source files though :-((()
> 

As far as I know the "static boottime flag" in Windows simply loads one
of several possible kernels.

	-hpa


