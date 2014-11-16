Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbaKPJce (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 04:32:34 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:37561 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaKPJca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 04:32:30 -0500
MIME-Version: 1.0
In-Reply-To: <1415925495-59312-4-git-send-email-joestringer@nicira.com>
References: <1415925495-59312-1-git-send-email-joestringer@nicira.com>
	<1415925495-59312-4-git-send-email-joestringer@nicira.com>
Date: Sun, 16 Nov 2014 11:32:30 +0200
Message-ID: <CAJ3xEMg4cUmrMtx_CjejKF326yf1_7uNRzudU45Z8m+ggqrQ4Q@mail.gmail.com>
Subject: Re: [PATCHv2 net 3/4] net/mlx4_en: Implement ndo_gso_check()
From: Or Gerlitz <gerlitz.or@gmail.com>
To: Joe Stringer <joestringer@nicira.com>
Cc: Linux Netdev List <netdev@vger.kernel.org>,
        "sathya.perla" <sathya.perla@emulex.com>,
        "shahed.shaikh" <shahed.shaikh@qlogic.com>,
        Amir Vadai <amirv@mellanox.com>,
        dept-gelinuxnicdev <Dept-GELinuxNICDev@qlogic.com>,
        Tom Herbert <therbert@google.com>, alexander.duyck@gmail.com,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 2:38 AM, Joe Stringer <joestringer@nicira.com> wrote:
> Use vxlan_gso_check() to advertise offload support for this NIC.
>
> Signed-off-by: Joe Stringer <joestringer@nicira.com>

FWIW (since the patches is applied already...)

Acked-by: Or Gerlitz <ogerlitz@mellanox.com>

thanks for addressing this piece.
