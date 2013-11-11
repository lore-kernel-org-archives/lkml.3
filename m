Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab3KKHyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 02:54:49 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:45005 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab3KKHym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 02:54:42 -0500
Message-ID: <52808D34.70309@synopsys.com>
Date: Mon, 11 Nov 2013 13:24:28 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "christian.ruppert@abilis.com" <christian.ruppert@abilis.com>
Subject: Re: [GIT PULL] pin control bulk changes for v3.13
References: <CACRpkdYpuZec_JRAPYZHmB5qTYebKR6iBy5=RvBUUEXsuOu97Q@mail.gmail.com>
In-Reply-To: <CACRpkdYpuZec_JRAPYZHmB5qTYebKR6iBy5=RvBUUEXsuOu97Q@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 12:14 PM, Linus Walleij wrote:
> - Add the Abilis TB10x pin control driver used on the ARC
>   architecture. Also the corresponding GPIO driver is merged
>   through this tree, so the ARC has full support for pins
>   and GPIOs after this.

Only the actual DT changes in arch/arc/plat-tb10x are missing which will require a
2nd pull request for ARC for rc1 which could have been avoided had I bitched about
it earlier.

-Vineet
