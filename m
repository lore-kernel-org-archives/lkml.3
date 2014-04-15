Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbaDON5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:57:10 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44076 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbaDON5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:57:08 -0400
MIME-Version: 1.0
In-Reply-To: <87r44yixds.fsf@gmail.com>
References: <87r44yixds.fsf@gmail.com>
Date: Tue, 15 Apr 2014 09:57:06 -0400
Message-ID: <CADVnQynJD7WtSFUtr=es=XnL2i2nV2dERU_7bNr1n1wJArSVCQ@mail.gmail.com>
Subject: Re: [PATCH v2] ipv4: Add option to get TCP_FASTOPEN to getsockopt()
From: Neal Cardwell <ncardwell@google.com>
To: Kenjiro Nakayama <nakayamakenjiro@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 8:35 AM, Kenjiro Nakayama
<nakayamakenjiro@gmail.com> wrote:
> Hi,

Please omit the "Hi," at the top of the patch description, so the top
of the email can be used directly as a git commit description.

> TCP_FASTOPEN option can be set via setsockopt(), but the value cannot be
> gotten via getsockopt(). This patch adds the option to getsockopt().
>
> Sighned-off-by: Kenjiro Nakayama <nakayamakenjiro@gmail.com>

Typo: this should be "Signed-off-by:"

>         Add option to get TCP_FASTOPEN to getsockopt()

Likewise, please omit the extra descriptive text below the
"Signed-off-by:" footer.

(And, of course, please note Eric's remarks as well...)

thanks,
neal
