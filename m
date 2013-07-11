Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab3GKSIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 14:08:17 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:35463 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab3GKSIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 14:08:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAH2r5mt5GH=6624e4t9hELmkR+H0t20+C1Fvrv_o-=nGm5nS=A@mail.gmail.com>
References: <CAN_LGv2zhu3zWd+7Jmi9FZd728W5T5kte2P0FMWABzENmyKJ5w@mail.gmail.com>
	<CAKywueQXGN+W6eMyZ-eQD+pCpgRz86Dpxht+YiMVKAGXVebPFg@mail.gmail.com>
	<CAH2r5mt5GH=6624e4t9hELmkR+H0t20+C1Fvrv_o-=nGm5nS=A@mail.gmail.com>
Date: Thu, 11 Jul 2013 22:08:15 +0400
Message-ID: <CAKywueR=tAUJzfwnB0d6af-DPJwmpuihAtN=NmNfy4GKaZf37w@mail.gmail.com>
Subject: Re: CIFS-related deadlock in 3.10-rc7
From: Pavel Shilovsky <piastryyy@gmail.com>
To: Steve French <smfrench@gmail.com>
Cc: "Alexander E. Patrakov" <patrakov@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/11 Steve French <smfrench@gmail.com>:
> Wouldn't this be a candidate for stable?

 Yes, I think it should go to stable as well as "[PATCH 1/8] CIFS: Fix
lease context buffer parsing" patch.

--
Best regards,
Pavel Shilovsky.
