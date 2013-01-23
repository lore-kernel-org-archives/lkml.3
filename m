Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab3AWJVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:21:37 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:39081 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050Ab3AWJVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:21:35 -0500
Message-ID: <50FFAB9B.4040408@ti.com>
Date: Wed, 23 Jan 2013 10:21:31 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: Tony Lindgren <tony@atomide.com>, <gregkh@linuxfoundation.org>,
        <balbi@ti.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "drivers/misc/ti-st: remove gpio handling"
References: <1358766762-24405-1-git-send-email-coelho@ti.com>   <20130122201453.GR22517@atomide.com>  <1358890299.6252.166.camel@cumari.coelho.fi> <50FFA7A9.9040709@ti.com>  <50FFA7F5.1000104@ti.com> <1358932452.6252.169.camel@cumari.coelho.fi>
In-Reply-To: <1358932452.6252.169.camel@cumari.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2013 10:14 AM, Luciano Coelho wrote:
> Yes, most likely we can use usleep or something.  I'll look into that as
> part of my clean-up series. ;)

I would suggest to use usleep_range() instead of usleep() if you can.

-- 
Péter
