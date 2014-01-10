Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232AbaAJCBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 21:01:03 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21155 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbaAJCBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 21:01:00 -0500
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH 00/14] target: Initial support for DIF Type1+Type3 emulation
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
Date: Thu, 09 Jan 2014 21:00:46 -0500
In-Reply-To: <1389212157-14540-1-git-send-email-nab@daterainc.com> (Nicholas
	A. Bellinger's message of "Wed, 8 Jan 2014 20:15:43 +0000")
Message-ID: <yq1mwj4sii9.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Nic" == Nicholas A Bellinger <nab@daterainc.com> writes:

Nic> This series contains initial support for target mode DIF
Nic> Type1+Type3 emulation within target core, RAMDISK_MCP device
Nic> backend, and tcm_loop fabric driver.

Super cool! Do you have a git tree so I can start tinkering with this?

I'll start reviewing the pieces tomorrow.

-- 
Martin K. Petersen	Oracle Linux Engineering
