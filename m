Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab3AQFI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 00:08:28 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:47436 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab3AQFI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 00:08:26 -0500
Message-ID: <50F7873C.1030304@synopsys.com>
Date: Thu, 17 Jan 2013 10:38:12 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.cross-arch,gmane.linux.kernel
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC Patch v1 48/55] ARC: [plat-arfpga] BVCI Latency Unit setup
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com> <1352720953-24321-18-git-send-email-vgupta@synopsys.com> <201211121402.45019.arnd@arndb.de>
In-Reply-To: <201211121402.45019.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2012 07:32 PM, Arnd Bergmann wrote:
> On Monday 12 November 2012, Vineet.Gupta1@synopsys.com wrote:
>> +       /* TBD: rewrite this using I/O macros */
>> +       volatile unsigned int *base = (unsigned int *)BVCI_LAT_UNIT_BASE;
>> +       volatile unsigned int *lat_unit = (unsigned int *)base + 21;
>> +       volatile unsigned int *lat_val = (unsigned int *)base + 22;
> 
> Yes, you should do as the comment says.
> 
> 	Arnd
> 

Done.

Thx,
-Vineet
