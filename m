Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbaFKMCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 08:02:21 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:54871 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbaFKMCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:02:20 -0400
Date: Wed, 11 Jun 2014 16:02:15 +0400
From: Dmitry Popov <ixaphire@qrator.net>
To: Dmitry Popov <ixaphire@qrator.net>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] ip_vti: fix sparse warnings for VTI_ISVTI
Message-Id: <20140611160215.7b0fbe7c4f42cf02b5496852@qrator.net>
In-Reply-To: <20140611150914.c3cb48bb8a1a760564f5db6e@qrator.net>
References: <20140611150914.c3cb48bb8a1a760564f5db6e@qrator.net>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014 15:09:14 +0400
Dmitry Popov <ixaphire@qrator.net> wrote:

> 
> Since VTI_ISVTI is always used with ip_tunnel_parm->i_flags (which is __be16),
> we can __force cast VTI_ISVTI to __be16 in header file.
> 

If this patch is okay I will submit it to iproute2 too. if_tunnel.h has to be
synced.
