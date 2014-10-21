Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbaJUEVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:21:14 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:51055 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbaJUEVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:21:12 -0400
Date: Tue, 21 Oct 2014 05:21:08 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: [PATCH 2/3] scsi: add try_rc16 blacklist flag
Message-ID: <20141021042108.GB11691@sucs.org>
References: <20141010074901.GA32028@sucs.org>
 <20141010075251.GC32028@sucs.org>
 <yq1mw8y6sxf.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1mw8y6sxf.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 09:08:28PM -0400, Martin K. Petersen wrote:
> >>>>> "Sitsofe" == Sitsofe Wheeler <sitsofe@gmail.com> writes:
> 
> Sitsofe> Microsoft Hyper-V virtual disks currently only claim SPC-2
> Sitsofe> compliance causing the kernel skip checks for features such as
> Sitsofe> thin provisioning even though the virtual disk advertises them.
> 
> Last time around we identified this as a problem with Microsoft's
> interpretation of the T10 SBC spec. And they promised that they are
> going to fix that.

OK but if we were happy to wait for Microsoft to fix the problem on the
host why were the (broken and incomplete) BLIST_SKIP_VPD_PAGES patches
committed to 3.17 rather than withdrawn? What's going to be done about
those patches now?

-- 
Sitsofe | http://sucs.org/~sits/
