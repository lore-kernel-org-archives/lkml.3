Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaBERaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:30:30 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:43447 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbaBERa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:30:28 -0500
MIME-Version: 1.0
In-Reply-To: <1391585905-24851-1-git-send-email-geert@linux-m68k.org>
References: <1391585905-24851-1-git-send-email-geert@linux-m68k.org>
Date: Wed, 5 Feb 2014 09:30:25 -0800
Message-ID: <CAHA+R7Pw_A4SLVL5=3i47MeMiYAgMRTTyWV5yN5c6LmGvWbTGA@mail.gmail.com>
Subject: Re: [PATCH] ipv4: Fix runtime WARNING in rtmsg_ifa()
From: Cong Wang <cwang@twopensource.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "David S. Miller" <davem@davemloft.net>, Jiri Pirko <jiri@resnulli.us>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 11:38 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Apparently commit 5c766d642bcaffd0c2a5b354db2068515b3846cf ("ipv4:
> introduce address lifetime") forgot to take into account the addition of
> struct ifa_cacheinfo in inet_nlmsg_size(). Hence add it, like is already
> done for ipv6.
>
> Suggested-by: Cong Wang <cwang@twopensource.com>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Signed-off-by: Cong Wang <cwang@twopensource.com>

Seems a candidate for -stable.
