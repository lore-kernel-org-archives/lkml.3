Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760711Ab3B0Sxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 13:53:33 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:43418 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab3B0Sxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 13:53:32 -0500
Date: Wed, 27 Feb 2013 19:53:28 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: John Spencer <maillist-linux@barfooze.de>
Cc: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [PATCH 0/3] build linux-next without perl
Message-ID: <20130227185328.GA27243@merkur.ravnborg.org>
References: <512E3A83.2050501@barfooze.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512E3A83.2050501@barfooze.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 05:55:31PM +0100, John Spencer wrote:
> Rob Landley wrote:
>>  Before 2.6.25 building Linux never required perl. This patch series 
> removes
>>  the requirement from basic kernel builds (tested on i686, x86_64, arm, 
>> 
> mips,
>>  powerpc, sparc, sh4, and m68k). Now updated to 3.8-rc1.
>
> using this patch series since 2.6.32 in sabotage linux, it is highly  
> useful and it's about time to get it merged.
> tested against linux 3.8, works perfectly.

Why do you apply this patch serie to sabotage linux?

	Sam
