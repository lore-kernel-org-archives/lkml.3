Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750910Ab3IFGkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 02:40:33 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:60327 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750788Ab3IFGkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 02:40:32 -0400
Date: Fri, 6 Sep 2013 08:40:30 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: problem fetching the watchdog tree
Message-ID: <20130906064029.GB28275@spo001.leaseweb.com>
References: <20130906090550.1b995b91877609b9361f99ae@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130906090550.1b995b91877609b9361f99ae@canb.auug.org.au>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

> Fetching the wireless tree yesterday and today produced this error:
> 
> fatal: unable to connect to www.linux-watchdog.org:
> www.linux-watchdog.org[0: 83.149.101.17]: errno=Connection refused

Strange. I had a git zombie process, got rid of it i2 days ago and
restarted git but apparently it didn't do anything anymore.
I just restarted it and saw a pull coming in again. So it is fixed now.

Thanks for pointing it out.
Wim.

