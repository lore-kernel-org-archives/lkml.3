Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbaCFDz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 22:55:27 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:61283 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991AbaCFDzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 22:55:23 -0500
MIME-Version: 1.0
In-Reply-To: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
References: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
Date: Thu, 6 Mar 2014 11:55:22 +0800
Message-ID: <CABb+yY2NtSZMYzeb7F8mTW-gBcq8sJPEXKBtpRRUd6NBZhwB9w@mail.gmail.com>
Subject: Re: [PATCHv3] Generic Mailbox API
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Suman Anna <s-anna@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        "Omar Ramirez Luna (omar.ramirez@copitl.com)" 
	<omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jassi Brar <jaswinder.singh@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 16, 2014 at 2:22 AM, Jassi Brar <jassisinghbrar@gmail.com> wrote:
> Hello,
>
>   Here is what the generic mailbox api looks like after modifications
> to make it work with 5 different platforms.
>  Major feedback from Suman Anna(TI), LeyFoon Tan(Intel),
> Craig McGeachie(Broadcom) and Loic Pallardy(ST).
>
If there are no more comments, I plan to implement suggestion on this
submission and issue v4 early next week (right now I am at Linaro
Connect).

Thanks
Jassi
