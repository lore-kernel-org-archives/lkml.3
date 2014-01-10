Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaAJU5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 15:57:22 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34578 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaAJU5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 15:57:19 -0500
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH 08/14] target/spc: Expose ATO bit in control mode page
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	<1389212157-14540-9-git-send-email-nab@daterainc.com>
Date: Fri, 10 Jan 2014 15:57:05 -0500
In-Reply-To: <1389212157-14540-9-git-send-email-nab@daterainc.com> (Nicholas
	A. Bellinger's message of "Wed, 8 Jan 2014 20:15:51 +0000")
Message-ID: <yq1a9f3r1we.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "nab" == Nicholas A Bellinger <nab@daterainc.com> writes:

nab> This patch updates spc_modesense_control() to set the Application
nab> Tag Owner (ATO) bit when when DIF emulation is enabled by the
nab> backend device.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
