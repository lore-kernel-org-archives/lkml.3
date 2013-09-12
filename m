Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab3ILObF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:31:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47060 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab3ILObC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:31:02 -0400
MIME-Version: 1.0
In-Reply-To: <20130912131655.GA8619@hmsreliant.think-freely.org>
References: <1378496168-3684-1-git-send-email-nhorman@tuxdriver.com>
	<CACVXFVPRWEXMHyGhfZVGX2HrL3cguqVBUjTS51r2p8EGt=EPdg@mail.gmail.com>
	<20130911141943.GA3181@neilslaptop.think-freely.org>
	<CACVXFVNfkfsSJJUK_BWHLnddk=NAWDJoERmg_qycYa11G_X2RA@mail.gmail.com>
	<20130912131655.GA8619@hmsreliant.think-freely.org>
Date: Thu, 12 Sep 2013 22:30:59 +0800
Message-ID: <CACVXFVP45r2HHonckK+mbiX9BkpxwQoDAbzy2dwXa_DwJHe=cA@mail.gmail.com>
Subject: Re: [PATCH] firmware: Be a bit more verbose about direct firmware
 loading failure
From: Ming Lei <ming.lei@canonical.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 9:16 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
>>
> Please re-read the patch, then point out to me which printk the above action
> will trigger, because its not happening in my testing. If you'll take a look at
> fw_get_filesystem_firmware, you'll see that if the filp_open on a firmware file
> fails, we continue the for loop through the list of available search paths.  No
> error is generated in the case you describe above.

You are right, sorry for missing "if (IS_ERR(file))  continue;",  and looks the
patch is good.

Acked-by: Ming Lei <ming.lei@canonical.com>

Thanks,
--
Ming Lei
