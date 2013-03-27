Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab3C0AeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 20:34:23 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:10988 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab3C0AeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 20:34:22 -0400
Message-ID: <1364344455.2922.4.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH 138/150] sfc: Disable soft interrupt handling during
 efx_device_detach_sync()
From: Ben Hutchings <bhutchings@solarflare.com>
To: Luis Henriques <luis.henriques@canonical.com>
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <kernel-team@lists.ubuntu.com>
Date: Wed, 27 Mar 2013 00:34:15 +0000
In-Reply-To: <1364311249-14454-139-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
	 <1364311249-14454-139-git-send-email-luis.henriques@canonical.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19748.005
X-TM-AS-Result: No--17.841100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-26 at 15:20 +0000, Luis Henriques wrote:
> 3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.
[...]

I applied all 16 of the sfc patches on top of 3.5.7.8 and the result
passed our standard 'overnight' test suite for in-tree drivers.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

