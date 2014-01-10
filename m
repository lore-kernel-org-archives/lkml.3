Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbaAJVJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 16:09:45 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18029 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaAJVJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 16:09:43 -0500
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH 14/14] tcm_loop: Enable DIF/DIX modes in SCSI host LLD
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	<1389212157-14540-15-git-send-email-nab@daterainc.com>
Date: Fri, 10 Jan 2014 16:09:26 -0500
In-Reply-To: <1389212157-14540-15-git-send-email-nab@daterainc.com> (Nicholas
	A. Bellinger's message of "Wed, 8 Jan 2014 20:15:57 +0000")
Message-ID: <yq1wqi7pmrd.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "nab" == Nicholas A Bellinger <nab@daterainc.com> writes:

nab> This patch updates tcm_loop_driver_probe() to set protection
nab> information using scsi_host_set_prot() and scsi_host_set_guard(),
nab> which currently enabled all modes of DIF/DIX protection, minus DIF
nab> TYPE0.

ITYM, DIX Type 0. And ideally you'd have a way to choose between IP and
T10 CRC for the guard type.

Otherwise OK.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
