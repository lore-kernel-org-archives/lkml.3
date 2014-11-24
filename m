Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbaKXP4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:56:11 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:35941 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaKXP4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:56:08 -0500
MIME-Version: 1.0
In-Reply-To: <20141124123859.GD7310@yliu-dev.sh.intel.com>
References: <20141124123859.GD7310@yliu-dev.sh.intel.com>
From: Willem de Bruijn <willemb@google.com>
Date: Mon, 24 Nov 2014 10:55:37 -0500
Message-ID: <CA+FuTSfE5dU7TOzHB_X-esvMVJ=Q2MyrKaTJc7UzQV6vS7piew@mail.gmail.com>
Subject: Re: [LKP] [net] 4ed2d765dfa:
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 7:38 AM, Yuanhan Liu
<yuanhan.liu@linux.intel.com> wrote:
> FYI, we noticed the below changes on
>
> commit 4ed2d765dfaccff5ebdac68e2064b59125033a3b ("net-timestamp: TCP timestamping")

> e7fd2885385157d4  4ed2d765dfaccff5ebdac68e20
> ----------------  --------------------------
>            :10         100%           5:5     ltp.recv01.fail
>            :10         100%           5:5     ltp.recvfrom01.fail
>            :10         100%           5:5     ltp.recvmsg01.fail

This has been discussed before:

  LTP recv/recvmsg tests failing on 3.17
  http://comments.gmane.org/gmane.linux.network/331750

and

  https://lkml.org/lkml/2014/10/1/379
