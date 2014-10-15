Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbaJOBIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 21:08:43 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42443 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872AbaJOBIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 21:08:41 -0400
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: [PATCH 2/3] scsi: add try_rc16 blacklist flag
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20141010074901.GA32028@sucs.org>
	<20141010075251.GC32028@sucs.org>
Date: Tue, 14 Oct 2014 21:08:28 -0400
In-Reply-To: <20141010075251.GC32028@sucs.org> (Sitsofe Wheeler's message of
	"Fri, 10 Oct 2014 08:52:51 +0100")
Message-ID: <yq1mw8y6sxf.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sitsofe" == Sitsofe Wheeler <sitsofe@gmail.com> writes:

Sitsofe> Microsoft Hyper-V virtual disks currently only claim SPC-2
Sitsofe> compliance causing the kernel skip checks for features such as
Sitsofe> thin provisioning even though the virtual disk advertises them.

Last time around we identified this as a problem with Microsoft's
interpretation of the T10 SBC spec. And they promised that they are
going to fix that.

-- 
Martin K. Petersen	Oracle Linux Engineering
