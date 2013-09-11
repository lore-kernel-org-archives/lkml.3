Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab3IKQmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:42:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41371 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab3IKQmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:42:18 -0400
Message-ID: <52309D58.7080800@canonical.com>
Date: Wed, 11 Sep 2013 12:42:00 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: stephen@networkplumber.org
CC: "davem@davemloft.net" <davem@davemloft.net>, mlindner@marvell.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [v3.11][Regression][Resend] skge: add dma_mapping check
References: <521E1552.4010100@canonical.com>
In-Reply-To: <521E1552.4010100@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Stephen,
>
> A bug was opened against the Ubuntu kernel[0].  A bug has also been
> opened in bugzilla[1].  After a kernel bisect, it was found that
> reverting the following commit resolved this bug:
>
> commit 136d8f377e1575463b47840bc5f1b22d94bf8f63
> Author: stephen hemminger <stephen@networkplumber.org>
> Date:   Sun Aug 4 17:22:34 2013 -0700
>
>     skge: add dma_mapping check
>
>
> The regression was introduced as of v3.11-rc6.
>
> I see that you are the author of this patch, so I wanted to run this by
> you.  I was thinking of requesting a revert for v3.11, but I wanted to
> get your feedback first.
>
>
> Thanks,
>
> Joe
>
> [0] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1216745
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=60784

