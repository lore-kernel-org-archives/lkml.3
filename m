Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab3JNLOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 07:14:36 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59724 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754582Ab3JNLOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 07:14:35 -0400
Message-ID: <525BD218.9060204@free-electrons.com>
Date: Mon, 14 Oct 2013 13:14:32 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Johannes Thumshirn <johannes.thumshirn@men.de>
CC: dougthompson@xmission.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] EDAC: remove deprecated IRQF_DISABLED
References: <1381641477-7373-1-git-send-email-michael.opdenacker@free-electrons.com> <20131014095602.GA14274@jtlinux>
In-Reply-To: <20131014095602.GA14274@jtlinux>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

On 10/14/2013 11:56 AM, Johannes Thumshirn wrote:
> Hi Michael,
>
> mpc85xx_edac has them already removed in the version that is going into 3.13.
>
> Sorry for the inconvenience. I'll set up a public tree at my github repo, so
> everyone can see the current mpc85xx_edac state.
Thank you for the good news. Don't be sorry, what matters is that this
gets fixed in mainline, and this didn't take me more than 2 or 3 minutes
to prepare and submit ;)

Cheers,

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

