Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab3HZOFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 10:05:50 -0400
Received: from server506d.appriver.com ([50.56.144.156]:53119 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751746Ab3HZOFt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 10:05:49 -0400
X-Note-AR-ScanTimeLocal: 8/26/2013 9:05:46 AM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-Virus-Scan: V-
X-Note-SnifferID: 0
X-Note: TCH-CT/SI:0-90/SG:2 8/26/2013 9:04:54 AM
X-GBUdb-Analysis: 0, 10.242.229.139, Ugly c=1 p=-0.914049 Source White
X-Signature-Violations: 0-0-0-1912-c
X-Note-419: 0 ms. Fail:0 Chk:1343 of 1343 total
X-Note: SCH-CT/SI:0-1343/SG:1 8/26/2013 9:05:28 AM
X-Note: Spam Tests Failed: 
X-Country-Path: ->PRIVATE->UNITED STATES
X-Note-Sending-IP: 10.242.229.139
X-Note-Reverse-DNS: 
X-Note-Return-Path: ecashin@coraid.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G340 G341 G342 G343 G347 G348 G455 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: VALID
X-Note: Headers Injected
Subject: Re: [PATCH] aoe: suppress compiler warnings
MIME-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="windows-1252"
From: Ed Cashin <ecashin@coraid.com>
In-Reply-To: <1377510328-25939-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Mon, 26 Aug 2013 10:05:44 -0400
CC: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Transfer-Encoding: 8BIT
Message-ID: <F2389973-E44A-49A2-B188-7FCA9DBAE2DE@coraid.com>
References: <1377510328-25939-1-git-send-email-andriy.shevchenko@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
X-Mailer: Apple Mail (2.1085)
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 26, 2013, at 5:45 AM, Andy Shevchenko wrote:

> This patch fixes following compiler warnings:
> 
> drivers/block/aoe/aoecmd.c: In function ‘aoecmd_ata_rw’:
> drivers/block/aoe/aoecmd.c:383:17: warning: variable ‘t’ set but not used [-Wunused-but-set-variable]
>  struct aoetgt *t;
>                 ^

Looks good, thanks.

-- 
  Ed Cashin
  ecashin@coraid.com


