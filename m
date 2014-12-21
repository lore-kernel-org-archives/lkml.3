Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbaLULTl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 06:19:41 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:36986 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbaLULTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 06:19:37 -0500
MIME-Version: 1.0
In-Reply-To: <1419115000-12178-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1419115000-12178-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Sun, 21 Dec 2014 14:19:36 +0300
Message-ID: <CALFYKtC_mbeUPtJtLak+8KibDXB-M0VdOoFQxQ=ifpAeSNvhdw@mail.gmail.com>
Subject: Re: [PATCH] net: ceph: armor.c: Remove unused function
From: Ilya Dryomov <ilya.dryomov@inktank.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Sage Weil <sage@inktank.com>, "David S. Miller" <davem@davemloft.net>,
        Ceph Development <ceph-devel@vger.kernel.org>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 1:36 AM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Remove the function ceph_armor() that is not used anywhere.
>
> This was partially found by using a static code analysis program called cppcheck.

It's ceph_unarmor()'s counterpart - so same as for "[PATCH] net: ceph:
crypto.c: Remove some unused functions".

Thanks,

                Ilya
