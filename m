Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbaIVPxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:53:45 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:47524 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbaIVPxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:53:44 -0400
MIME-Version: 1.0
In-Reply-To: <201409221130.s8MBUQls003040@clem.clem-digital.net>
References: <201409221130.s8MBUQls003040@clem.clem-digital.net>
Date: Mon, 22 Sep 2014 08:53:43 -0700
Message-ID: <CAM_iQpXQcM2E2oez+nNbbecd25fXqOKNqAfoOgCfQ72-VfBOUA@mail.gmail.com>
Subject: Re: Corrupt Network Packets -- 3.17-rc5/rc6
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Pete Clements <clem@clem.clem-digital.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Networking bug report needs to go netdev@)

On Mon, Sep 22, 2014 at 4:30 AM, Pete Clements
<clem@clem.clem-digital.net> wrote:
> Heads up fyi: system is i386 UP.
>
> Started getting some pop3 reception errors from the above system.
> Investigating the problem discovered scp of the mailbox failed
> with "Corrupted MAC on input"
>
> Problem started with rc5, still in rc6. Running rc4 with no
> problem.
>
> Sorry for lack of better definition.


Which driver are you using?
