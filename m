Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab3LFJ2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:28:46 -0500
Received: from zimbra.real-time.com ([63.170.91.9]:54272 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757509Ab3LFJ2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:28:43 -0500
Date: Fri, 6 Dec 2013 20:28:22 +1100
From: James Cameron <quozl@laptop.org>
To: Sergei Ianovich <ynvich@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Jiri Slaby <jslaby@suse.cz>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Zhou Zhu <zzhu3@marvell.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Stefan Seyfried <seife+kernel@b1-systems.com>,
        John Crispin <blogic@openwrt.org>, Paul Bolle <pebolle@tiscali.nl>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2] serial: rewrite pxa2xx-uart to use 8250_core
Message-ID: <20131206092822.GP16425@us.netrek.org>
References: <1386286149-2855-1-git-send-email-ynvich@gmail.com>
 <1386321003-8960-1-git-send-email-ynvich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386321003-8960-1-git-send-email-ynvich@gmail.com>
Organization: Netrek Vanilla Server Dictator
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 01:09:31PM +0400, Sergei Ianovich wrote:
> pxa2xx-uart was a separate uart platform driver. It was declaring
> the same device names and numbers as 8250 driver. As a result,
> it was impossible to use 8250 driver on PXA SoCs.
> 
> Upon closer examination pxa2xx-uart turned out to be a clone of
> 8250_core driver.
> 
> Workaround for Erratum #19 according to Marvel(R) PXA270M Processor
> Specification Update (April 19, 2010) is dropped. 8250_core reads
> from FIFO immediately after checking DR bit in LSR.

Reviewed-by: James Cameron <quozl@laptop.org>

Thanks.

(for my notes ... V1 has passed 4.5 hours in OLPC's RUNIN test.)

-- 
James Cameron
http://quozl.linux.org.au/
