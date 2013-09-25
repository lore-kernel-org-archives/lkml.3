Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab3IYWYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:24:34 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:40516 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3IYWYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:24:33 -0400
MIME-Version: 1.0
In-Reply-To: <89eb744f1a77b32d6ec718618f356df3188403e7.1380137609.git.joe@perches.com>
References: <cover.1380137609.git.joe@perches.com>
	<89eb744f1a77b32d6ec718618f356df3188403e7.1380137609.git.joe@perches.com>
Date: Thu, 26 Sep 2013 02:24:32 +0400
Message-ID: <CA++WF2PdHWvcsQtxaM-TLqqZ6PcU2uABeB-qnxmAC+FaQgHy0A@mail.gmail.com>
Subject: Re: [PATCH 06/11] ipw2x00: Remove extern from function prototypes
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On 25 September 2013 23:37, Joe Perches <joe@perches.com> wrote:
> There are a mix of function prototypes with and without extern
> in the kernel sources.  Standardize on not using extern for
> function prototypes.
>
> Function prototypes don't need to be written with extern.
> extern is assumed by the compiler.  Its use is as unnecessary as
> using auto to declare automatic/local variables in a block.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---

Looks fine, thanks.

Stanislav.
