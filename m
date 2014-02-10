Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaBJLXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:23:43 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:61124 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbaBJLXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:23:42 -0500
X-IronPort-AV: E=Sophos;i="4.95,817,1384300800"; 
   d="scan'208";a="99435606"
Message-ID: <52F8B6BB.6040205@citrix.com>
Date: Mon, 10 Feb 2014 11:23:39 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Rashika Kheria <rashika.kheria@gmail.com>
CC: <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        <xen-devel@lists.xenproject.org>, <josh@joshtriplett.org>
Subject: Re: [PATCH 2/4] drivers: xen: Include appropriate header file in
 pcpu.c
References: <3826f170dae13e3ee700ad9e26a8c88be4b7aaa2.1391943416.git.rashika.kheria@gmail.com> <a7672a06595d907ce9aacc65b3cbe0179684f5e0.1391943416.git.rashika.kheria@gmail.com>
In-Reply-To: <a7672a06595d907ce9aacc65b3cbe0179684f5e0.1391943416.git.rashika.kheria@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/14 11:01, Rashika Kheria wrote:
> Include appropriate header file in xen/pcpu.c because include/xen/acpi.h
> contains prototype declaration of functions defined in the file.
> 
> This eliminates the following warning in xen/pcpu.c:
> drivers/xen/pcpu.c:336:6: warning: no previous prototype for ‘xen_pcpu_hotplug_sync’ [-Wmissing-prototypes]
> drivers/xen/pcpu.c:346:5: warning: no previous prototype for ‘xen_pcpu_id’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
