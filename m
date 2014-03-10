Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaCJLRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 07:17:39 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:63902 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbaCJLRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 07:17:36 -0400
Message-ID: <531D9F4B.6040505@gmail.com>
Date: Mon, 10 Mar 2014 12:17:31 +0100
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: linux-sunxi@googlegroups.com,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-doc@vger.kernel.org,
        dev@linux-sunxi.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [linux-sunxi] Re: [RFC PATCH v2 08/14] mtd: nand: add sunxi NAND
 flash controller support
References: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com> <1391006064-28890-9-git-send-email-b.brezillon.dev@gmail.com> <20140129175641.GF1427@obsidianresearch.com> <20140129184619.GC27143@localhost> <20140129191005.GG1427@obsidianresearch.com>
In-Reply-To: <20140129191005.GG1427@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jason,

Le 29/01/2014 20:10, Jason Gunthorpe a écrit :
> On Wed, Jan 29, 2014 at 03:46:20PM -0300, Ezequiel Garcia wrote:
>
>> After CE# has been pulled high and then transitioned low again, the host
>> should issue a Set Features to select the appropriate asynchronous timing mode.
>> """
> Oh, I had forgot you should do a set feature too
>
> Boris, I think the core core should handle this dance and the driver
> should just implement a call back to change the timing mode on the
> interface..
>
> If I ever get a moment I can work on support for timing setting in the
> mvebu driver, I have boards here with ONFI NAND..

Any progress on this ?
I'm about to post the 3rd version of this series and if you already have
something working I could base my work on your proposal.


Best Regards,

Boris
> Regards,
> Jason
>

