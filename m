Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbaGWIKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 04:10:42 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:64694 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbaGWIKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 04:10:40 -0400
Message-ID: <53CF6DE9.3090505@linaro.org>
Date: Wed, 23 Jul 2014 09:10:17 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH] serial/core: Fix too big allocation for attribute member
References: <20140723060622.2647.96316.stgit@yuno-kbuild.novalocal>
In-Reply-To: <20140723060622.2647.96316.stgit@yuno-kbuild.novalocal>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/07/14 07:06, Yoshihiro YUNOMAE wrote:
> Current code allocates too much data for tty_groups member of uart_port struct,
> so fix it.
> 
> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>

(using linux-next tree for context).
