Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab3KCUuY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 15:50:24 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:42012 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab3KCUuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 15:50:23 -0500
MIME-Version: 1.0
In-Reply-To: <038fa53ab9e9336e1732f9f841c296bfcde87b0a.1383442264.git.gamerh2o@gmail.com>
References: <038fa53ab9e9336e1732f9f841c296bfcde87b0a.1383442264.git.gamerh2o@gmail.com>
From: Mark Einon <mark.einon@gmail.com>
Date: Sun, 3 Nov 2013 20:50:06 +0000
Message-ID: <CANK3SE2r_h8ba7PAG85+DuBwf5F=qTqY+gZT-HK3NZGHRn6Zpw@mail.gmail.com>
Subject: Re: [PATCH 1/2] staging: et131x: drop packet when error occurs in et131x_tx()
To: ZHAO Gang <gamerh2o@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Einon <mark.einon@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 November 2013 01:40, ZHAO Gang <gamerh2o@gmail.com> wrote:
> Drop packet instead of return NETDEV_TX_BUSY when tx failed.
>
> Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>

Hi,

Looks good. If you could also send a patch to remove this item from the
et131x/README TODO list, then I'm happy to add:

Acked-by: Mark Einon <mark.einon@gmail.com>

Cheers,

Mark
