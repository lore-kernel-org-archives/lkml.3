Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbaGCRX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 13:23:27 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:42562 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaGCRX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 13:23:26 -0400
MIME-Version: 1.0
In-Reply-To: <1404399414-32099-1-git-send-email-zlim.lnx@gmail.com>
References: <1404399414-32099-1-git-send-email-zlim.lnx@gmail.com>
Date: Thu, 3 Jul 2014 10:23:25 -0700
Message-ID: <CAMEtUuyVrzBM8eUo731MrNbQmSwZx9x5QkgoAqtXpi0xruif0w@mail.gmail.com>
Subject: Re: [PATCHv2 net-next] net: filter: move load_pointer() into filter.h
From: Alexei Starovoitov <ast@plumgrid.com>
To: Zi Shen Lim <zlim.lnx@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2014 at 7:56 AM, Zi Shen Lim <zlim.lnx@gmail.com> wrote:
> load_pointer() is already a static inline function.
> Let's move it into filter.h so BPF JIT implementations can reuse this
> function.
>
> Since we're exporting this function, let's also rename it to
> bpf_load_pointer() for clarity.
>
> Signed-off-by: Zi Shen Lim <zlim.lnx@gmail.com>

Acked-by: Alexei Starovoitov <ast@plumgrid.com>
