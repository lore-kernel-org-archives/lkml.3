Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbaHKK4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 06:56:20 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48549 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaHKK4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 06:56:19 -0400
Date: Mon, 11 Aug 2014 13:55:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oleg Drokin <oleg.drokin@intel.com>, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>,
        Hongchao Zhang <hongchao.zhang@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Alex Zhuravlev <alexey.zhuravlev@intel.com>,
        linux-kernel@vger.kernel.org, Ann Koehler <amk@cray.com>,
        Christoph Jaeger <email@christophjaeger.info>,
        Lisa Nguyen <lisa@xenapiadmin.com>
Subject: Re: [PATCH] staging: lustre: lustre: obdclass: genops.c: Cleaning up
 missing null-terminate after strncpy call
Message-ID: <20140811105550.GM4856@mwanda>
References: <1407628080-24789-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407628080-24789-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2014 at 01:48:00AM +0200, Rickard Strandqvist wrote:
> Added a guaranteed null-terminate after call to strncpy.
> 

No.  This one isn't needed.  The static checker *should* know this so it
is a problem with the static checker and not with the code.

Don't change code, just because the static checker has problems.

regards,
dan carpenter

