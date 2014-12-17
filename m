Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaLQH47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 02:56:59 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:17711 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbaLQH46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 02:56:58 -0500
Date: Wed, 17 Dec 2014 10:56:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Rorvick <chris@rorvick.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Greg Donald <gdonald@gmail.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Fabian Frederick <fabf@skynet.be>, James Simmons <uja.ornl@gmail.com>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] lprocfs_write_frac_u64_helper cleanup
Message-ID: <20141217075621.GM4911@mwanda>
References: <1418790242-14309-1-git-send-email-chris@rorvick.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418790242-14309-1-git-send-email-chris@rorvick.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 10:24:00PM -0600, Chris Rorvick wrote:
> Added a second patch to address Dan Carpenter's concern with the
> complexity of passing the sign through `mult'.  Compile tested only.


Thanks.  That does look cleaner.

regards,
dan carpenter

