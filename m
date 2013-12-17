Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab3LQVRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 16:17:54 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:39476 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab3LQVRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 16:17:52 -0500
MIME-Version: 1.0
In-Reply-To: <20131217200022.GD28274@kroah.com>
References: <20131217182733.GA16202@www.outflux.net>
	<20131217200022.GD28274@kroah.com>
Date: Tue, 17 Dec 2013 13:17:51 -0800
X-Google-Sender-Auth: g-g_pjGmZLIQYF21EKRhIJk5pM4
Message-ID: <CAGXu5j+wwkiz9=s3DBnmDXmtR_YdtqvXOe5PJsNbRcs_UCGajA@mail.gmail.com>
Subject: Re: [RESEND][PATCH] scsi: esas2r: fix potential format string flaw
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Bradley Grove <linuxdrivers@attotech.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 12:00 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Dec 17, 2013 at 10:27:33AM -0800, Kees Cook wrote:
>> This makes sure format strings cannot leak into the printk call via the
>> constructed buffer.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  drivers/scsi/esas2r/esas2r_log.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Why is this patch "To:" me?  I'm not the author of this driver, or the
> maintainer of it or the subsystem, and there's not much, if anything I
> can do with it...

I've resent this before, and since it lived in "drivers", I figured
you would be the next up the chain to take it (since it's been
ignored).

-Kees

-- 
Kees Cook
Chrome OS Security
