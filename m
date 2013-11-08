Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529Ab3KHXRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 18:17:38 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:39113 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757954Ab3KHXRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 18:17:37 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <alpine.LFD.2.03.1311081809050.15571@syhkavp.arg>
References: <20131106211352.GA24006@www.outflux.net>
	<alpine.LFD.2.03.1311081809050.15571@syhkavp.arg>
Date: Fri, 8 Nov 2013 15:17:34 -0800
Message-ID: <CAOesGMhCa5qFsJZ56ktA3MA+arx4WzSzkchZp+qKZmt=nKhpug@mail.gmail.com>
Subject: Re: [PATCH] ARM: make OABI default to off
From: Olof Johansson <olof@lixom.net>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 8, 2013 at 3:13 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
> On Wed, 6 Nov 2013, Kees Cook wrote:
>
>> Given recent discussions about the lack of OABI in the wild, switch
>> CONFIG_OABI_COMPAT to off-by-default to encourage more system builders
>> to avoid it.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> Acked-by: Nicolas Pitre <nico@linaro.org>

Yeah, sorry for the delay:

Acked-by: Olof Johansson <olof@lixom.net

(send to the patch tracker :)

-Olof
