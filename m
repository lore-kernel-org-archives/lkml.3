Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbaLULQO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 06:16:14 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:33134 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbaLULQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 06:16:11 -0500
MIME-Version: 1.0
In-Reply-To: <1419094326-9218-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1419094326-9218-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Sun, 21 Dec 2014 14:16:10 +0300
Message-ID: <CALFYKtAO5pK8CuM+zQPdHJHrjO=2DErDT4kDzga1sZUkLpAsxA@mail.gmail.com>
Subject: Re: [PATCH] net: ceph: crypto.c: Remove some unused functions
From: Ilya Dryomov <ilya.dryomov@inktank.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Sage Weil <sage@inktank.com>, "David S. Miller" <davem@davemloft.net>,
        Ceph Development <ceph-devel@vger.kernel.org>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2014 at 7:52 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Removes some functions that are not used anywhere:
> ceph_encrypt() ceph_decrypt() ceph_crypto_key_encode()
>
> This was partially found by using a static code analysis program called cppcheck.

I'd like to keep this stuff even if it's unused, unless Sage/others
want it gone.  ceph_crypto_key_encode() is ceph_crypto_key_decode()'s
counterpart and ceph_{en,de}crypt() are useful for reference purposes.

Thanks,

                Ilya
