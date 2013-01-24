Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184Ab3AXIaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 03:30:52 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:43510 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab3AXIan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 03:30:43 -0500
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Philip Avinash <avinashphilip@ti.com>
Cc: <dwmw2@infradead.org>, <artem.bityutskiy@linux.intel.com>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <rob@landley.net>, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, nsekhar@ti.com,
        linux-kernel@vger.kernel.org, gururaja.hebbar@ti.com,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH] mtd: devices: elm: Removes <xx> literals in elm DT node
References: <9580c5839ea64e09ddd61610ce922d7cd1adc861.1359010256.git.avinashphilip@ti.com>
Date: Thu, 24 Jan 2013 09:30:38 +0100
In-Reply-To: <9580c5839ea64e09ddd61610ce922d7cd1adc861.1359010256.git.avinashphilip@ti.com>
	(Philip Avinash's message of "Thu, 24 Jan 2013 12:23:30 +0530")
Message-ID: <8738xr2dap.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Philip" == Philip Avinash <avinashphilip@ti.com> writes:

 Philip> As part of removing generalized dependency, replace <xx>
 Philip> literal fields in DT compatible field with <52> for am335x
 Philip> platforms.

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

-- 
Bye, Peter Korsgaard
