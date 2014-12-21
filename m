Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbaLULYu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 06:24:50 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:48902 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbaLULYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 06:24:48 -0500
MIME-Version: 1.0
In-Reply-To: <1419078894-31656-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1419078894-31656-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Sun, 21 Dec 2014 14:24:47 +0300
Message-ID: <CALFYKtD7wTNiTzekkWKZqBEb_7egij31Fhe=7J2Ey+arT3M_vA@mail.gmail.com>
Subject: Re: [PATCH] net: ceph: ceph_strings.c: Remove unused function
From: Ilya Dryomov <ilya.dryomov@inktank.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Sage Weil <sage@inktank.com>, "David S. Miller" <davem@davemloft.net>,
        Ceph Development <ceph-devel@vger.kernel.org>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2014 at 3:34 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Remove the function ceph_pool_op_name() that is not used anywhere.
>
> This was partially found by using a static code analysis program called cppcheck.

It's part of pool op infrastructure and I'd rather we use it in
monc_show() than remove it.  I'll make a patch.

Thanks,

                Ilya
