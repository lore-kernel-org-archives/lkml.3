Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab3H2OS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:18:57 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56437 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753060Ab3H2OS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:18:56 -0400
Message-ID: <1377785936.1928.97.camel@joe-AO722>
Subject: Re: [PATCH v1.2 1/1] arcmsr: Support Areca new SATA Raid Adapter
 ARC1214/1224/1264/1284
From: Joe Perches <joe@perches.com>
To: Ching <ching2048@areca.com.tw>
Cc: jejb@kernel.com, thenzl@redhat.com, fengguang.wu@intel.com,
        dan.carpenter@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com
Date: Thu, 29 Aug 2013 07:18:56 -0700
In-Reply-To: <1377748071.4571.40.camel@CentOS6.4-64>
References: <1377748071.4571.40.camel@CentOS6.4-64>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-29 at 11:47 +0800, Ching wrote:
> From: Ching <ching2048@areca.com.tw>
> 
> Support Areca new SATA Raid Adapter ARC1214/1224/1264/1284
> Modify maximum outstanding command number.
> Notify command complete with auto request sense data.
> Fix bug of updating adapter firmware through ioctl(ARCHTTP) interface.
> Fix coding style warning.
> Fix compiling warning.
> Fix ARC188x hardware reset.
> Fix indent coding.

Hi again Ching.

I think it would be better to separate the coding style
warning and indent coding patches from the fixes and
send each line entry above as an individual patch.

> Singed-off-by: Ching <ching2048@areca.com.tw>

Typo here

Signed-off-by:


