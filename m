Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934080Ab3CMRsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:48:43 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:46826 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932905Ab3CMRsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:48:42 -0400
Message-ID: <5140BBF2.4050309@gmail.com>
Date: Wed, 13 Mar 2013 18:48:34 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: David Woodhouse <dwmw2@infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [PATCH] pinctrl: mvebu: prevent walking off the end of group
 array
References: <1362872371.3690.106.camel@shinybook.infradead.org> <1363196155-1620-1-git-send-email-jason@lakedaemon.net>
In-Reply-To: <1363196155-1620-1-git-send-email-jason@lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2013 06:35 PM, Jason Cooper wrote:
> From: David Woodhouse<dwmw2@infradead.org>
>
> While investigating (ab)use of krealloc, David found this bug.  It's
> unlikely to occur, but now we detect the condition and error out
> appropriately.
>
> Signed-off-by: David Woodhouse<David.Woodhouse@intel.com>
> Signed-off-by: Jason Cooper<jason@lakedaemon.net>
> ---
> David, please double check that this is as you intended.  I had to hand-jam it in due to some peculiarities on my side.
>

Jason,

thanks for preparing that patch. I ll test (and Ack) asap but that will not be
before this weekend. If Thomas and Andrew ack it before me, consider it good.

Sebastian
