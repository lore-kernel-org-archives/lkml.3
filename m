Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096Ab3JPHXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 03:23:36 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17695 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab3JPHXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 03:23:35 -0400
Message-ID: <525E3F88.9070004@oracle.com>
Date: Wed, 16 Oct 2013 15:26:00 +0800
From: vaughan <vaughan.cao@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Hannes Reinecke <hare@suse.de>, Steffen Maier <maier@linux.vnet.ibm.com>
CC: JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: special sense code asc,ascq=04h,0Ch abort scsi scan
 in the middle
References: <525AD704.6040705@oracle.com> <525BD1EA.6000701@suse.de> <525BE8C1.5090606@linux.vnet.ibm.com> <525BEF2B.2030907@suse.de> <525BF256.6060707@suse.de> <525C0CAE.3030803@linux.vnet.ibm.com> <525E37CA.2000605@suse.de>
In-Reply-To: <525E37CA.2000605@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 02:52 PM, Hannes Reinecke wrote:
> But seeing that this approach raises quite some issues I've attached a
> different patch. Vaughan, could you test with that, too? Should be
> functionally equivalent to the previous one. Cheers, Hannes 
Of course. This one is more clear to express our intention than setting
PQ 3 to break out.

Vaughan
