Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbaDSAmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 20:42:32 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:63045 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbaDSAma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 20:42:30 -0400
MIME-Version: 1.0
In-Reply-To: <87a9bljl7m.fsf@gmail.com>
References: <87a9bljl7m.fsf@gmail.com>
Date: Fri, 18 Apr 2014 20:42:28 -0400
Message-ID: <CADVnQyn-cxWv_5qd8ZwVyrty=PQr-aw2e7kVWgt+rA9_Jt5QJg@mail.gmail.com>
Subject: Re: [PATCH v3] tcp: Add a TCP_FASTOPEN socket option to get a max
 backlog on its listner
From: Neal Cardwell <ncardwell@google.com>
To: Kenjiro Nakayama <nakayamakenjiro@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 12:25 PM, Kenjiro Nakayama
<nakayamakenjiro@gmail.com> wrote:
> This patch adds a TCP_FASTOPEN socket option to get a max backlog on its
> listener to getsockopt().
>
> Signed-off-by: Kenjiro Nakayama <nakayamakenjiro@gmail.com>
> ---
>  net/ipv4/tcp.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Acked-by: Neal Cardwell <ncardwell@google.com>

Seems fine to me. Thanks, Kenjiro.

neal
