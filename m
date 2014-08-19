Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbaHSQEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 12:04:11 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:53054 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbaHSQEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 12:04:09 -0400
MIME-Version: 1.0
In-Reply-To: <1408393263-18027-1-git-send-email-cristos@vipserv.org>
References: <1408393263-18027-1-git-send-email-cristos@vipserv.org>
Date: Tue, 19 Aug 2014 11:04:09 -0500
X-Google-Sender-Auth: J_imfyWB3aQ8BCm31nWN45bVvYg
Message-ID: <CAL3LdT7+5FFbP5Rf1MoY2GJ9cQ0LJnecQb66ZA2ofwD28vy1jw@mail.gmail.com>
Subject: Re: [PATCH v2] drivers: net: ethernet: intel: e1000: e1000_ethertoo.c
 coding style fixes
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Krzysztof Majzerowicz-Jaszcz <cristos@vipserv.org>
Cc: Joe Perches <joe@perches.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 3:21 PM, Krzysztof Majzerowicz-Jaszcz
<cristos@vipserv.org> wrote:
> Fixed many errors/warnings and checks in e1000_ethtool.c reported by checkpatch.pl
> Suggestions from Joe Perches and Alexander Duyck applied as well
>
> Signed-off-by: Krzysztof Majzerowicz-Jaszcz <cristos@vipserv.org>
> ---
>  drivers/net/ethernet/intel/e1000/e1000_ethtool.c | 155 ++++++++++++-----------
>  1 file changed, 79 insertions(+), 76 deletions(-)
>

Thanks Krzysztof, I will add your patch to my queue and I can fix up
the patch title for you. :-)
