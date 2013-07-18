Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133Ab3GRQPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:15:53 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:58087 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab3GRQPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:15:52 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1307171420350.8258@kaball.uk.xensource.com>
References: <1373897706-15331-1-git-send-email-julien.grall@linaro.org> <alpine.DEB.2.02.1307171420350.8258@kaball.uk.xensource.com>
From: Julien Grall <julien.grall@linaro.org>
Date: Thu, 18 Jul 2013 17:15:21 +0100
Message-ID: <CAPnVf8yH7PBOSSC57qJv+pWmsinRUxGr81QUPH9GoOkKw2oo3Q@mail.gmail.com>
Subject: Re: [PATCH] arm: choose debug/uncompress.h include when uncompress
 debug is disabled
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux@arm.linux.org.uk, Ian Campbell <Ian.Campbell@citrix.com>,
        Patch Tracking <patches@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 July 2013 14:25, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
> On Mon, 15 Jul 2013, Julien Grall wrote:
>> Even if uncompress debug is disabled, some board will continue to print
>> information during uncompress step.
>
> Are you talking about DEBUG_UNCOMPRESS?
> Should I read the sentence as "even if DEBUG_UNCOMPRESS is not selected,
> some board will continue to print information during the uncompress step"?

Yes. On the arndale, uncompress log are directly output on UART-2.
This is annoying
because  Xen doesn't expose the UART to dom0.

> Isn't this a bug in the platform specific code that should be fixed anyway?
>
>> By using debug/uncompress.h include, all debug output will be disabled.
>
> I am not sure if this is the right solution to the problem.
> I think it might be better to add the appropriate ifdefs into the
> platform specific code.

--
Julien Grall
