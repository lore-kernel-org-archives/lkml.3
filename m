Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbaGGXWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:22:00 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:33313 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaGGXV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:21:57 -0400
Message-ID: <53BB2B5F.6080206@linux.vnet.ibm.com>
Date: Mon, 07 Jul 2014 18:21:03 -0500
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] ibmvfc: fix little endian issues
References: <1403827435-29522-1-git-send-email-tyreld@linux.vnet.ibm.com>
In-Reply-To: <1403827435-29522-1-git-send-email-tyreld@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070723-9332-0000-0000-0000014D82E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2014 07:03 PM, Tyrel Datwyler wrote:
> Added big endian annotations to relevant data structure fields, and necessary
> byte swappings to support little endian builds.

Acked-by: Brian King <brking@linux.vnet.ibm.com>

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


