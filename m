Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab3HPOub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 10:50:31 -0400
Received: from nbd.name ([46.4.11.11]:37328 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411Ab3HPOu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 10:50:28 -0400
Message-ID: <520E3A7E.7010507@phrozen.org>
Date: Fri, 16 Aug 2013 16:43:10 +0200
From: John Crispin <john@phrozen.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: David Daney <ddaney.cavm@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-mips@linux-mips.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v2 2/2] gpio MIPS/OCTEON: Add a driver for OCTEON's on-chip
 GPIO pins.
References: <1375133350-18828-1-git-send-email-ddaney.cavm@gmail.com>        <1375133350-18828-3-git-send-email-ddaney.cavm@gmail.com> <CACRpkdaM=hqwHhNxCLCEZudRNYsyW-bZMXzZyvuW4qs2fGaREw@mail.gmail.com>
In-Reply-To: <CACRpkdaM=hqwHhNxCLCEZudRNYsyW-bZMXzZyvuW4qs2fGaREw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/08/13 15:16, Linus Walleij wrote:
> I guess you will merge both patches through the MIPS arch
> tree?

Hi Linus,

sure, we can take them via the MIPS tree

	John
