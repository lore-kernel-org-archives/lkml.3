Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab3AVShi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 13:37:38 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:46625 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab3AVShe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 13:37:34 -0500
From: Christian Lamparter <chunkeey@googlemail.com>
To: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 16/20] drivers/net/wireless/p54: remove depends on CONFIG_EXPERIMENTAL
Date: Tue, 22 Jan 2013 19:37:16 +0100
User-Agent: KMail/1.13.7 (Linux/3.8.0-rc4-wl+; KDE/4.8.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
References: <1358879444-25834-1-git-send-email-keescook@chromium.org> <1358879444-25834-17-git-send-email-keescook@chromium.org>
In-Reply-To: <1358879444-25834-17-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301221937.16916.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aren't these patches going through wireless-next
or linux-next?

On Tuesday, January 22, 2013 07:30:40 PM Kees Cook wrote:
> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during the
> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
> 
> CC: Christian Lamparter <chunkeey@googlemail.com>
> CC: "John W. Linville" <linville@tuxdriver.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: NetDev <netdev@vger.kernel.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>
[Also ACK the carl9170, if necessary]

Regards,
	Chr
