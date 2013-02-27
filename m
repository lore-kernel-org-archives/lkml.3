Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760519Ab3B0RXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:23:37 -0500
Received: from furnace.wzff.de ([176.9.216.40]:49308 "EHLO furnace.wzff.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760474Ab3B0RXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:23:34 -0500
X-Greylist: delayed 1654 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Feb 2013 12:23:34 EST
Message-ID: <512E3A83.2050501@barfooze.de>
Date: Wed, 27 Feb 2013 17:55:31 +0100
From: John Spencer <maillist-linux@barfooze.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Mail/1.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 0/3] build linux-next without perl
In-Reply-To: 1361944667.957820@landley.net
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
>  Before 2.6.25 building Linux never required perl. This patch series 
removes
>  the requirement from basic kernel builds (tested on i686, x86_64, arm, 
mips,
>  powerpc, sparc, sh4, and m68k). Now updated to 3.8-rc1.

using this patch series since 2.6.32 in sabotage linux, it is highly 
useful and it's about time to get it merged.
tested against linux 3.8, works perfectly.

Acked-By: John Spencer <maillist-linux@barfooze.de>
