Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaLRJPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 04:15:01 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23618 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaLRJO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 04:14:59 -0500
Date: Thu, 18 Dec 2014 12:14:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Srikrishan Malik <srikrishanmalik@gmail.com>,
        devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, linux-kernel@vger.kernel.org,
        HPDD-discuss@ml01.01.org
Subject: Re: [PATCH] staging: lustre: lustre: mdc: mdc_lib.c: Removed an
 unnecessary NULL check
Message-ID: <20141218091446.GO4856@mwanda>
References: <1418856173-8222-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418856173-8222-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 11:42:53PM +0100, Rickard Strandqvist wrote:
> Removed an unnecessary NULL check.
> I have checked the only place this function is called from.

Next time, in the changelog mention that the checking isn't consistent
so it creates as static checker warning.  That is a good motivation for
writing these patches.

Anway, looks good.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

