Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab3ERVUU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 17:20:20 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:42262 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab3ERVUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 17:20:18 -0400
Date: Sat, 18 May 2013 23:20:13 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Petko Manolov <petkan@nucleusys.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] drivers: net: usb: rtl8150: bug fixing and code
 cleanup
Message-ID: <20130518212013.GA26921@electric-eye.fr.zoreil.com>
References: <alpine.DEB.2.02.1305182305110.16874@fry.nucleusys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305182305110.16874@fry.nucleusys.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Petko Manolov <petkan@nucleusys.com> :
[...]
> This patch series adds rtl8150.h, which contains structure and constant 
> definitons formerly found in rtl8150.c, removes socket buffer 
> pre-allocated pool and uses dynamically allocated memory for the 
> asynchronous URB requests, thus avoids clobbering the previously scheduled 
> for update value.
> 
> This patch series is against 'net' tree.

'net' tree takes fixes. The cleanup / fix ratio is imho a bit high
in this series. You may submit the fix part now and wait until
davem merges 'net' into 'net-next' to submit big cleanups against
net-next.

-- 
Ueimor
