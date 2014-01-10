Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827AbaAJUjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 15:39:36 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:41091 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaAJUje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 15:39:34 -0500
To: Sagi Grimberg <sagig@mellanox.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH 07/14] target/sbc: Add P_TYPE + PROT_EN bits to READ_CAPACITY_16
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	<1389212157-14540-8-git-send-email-nab@daterainc.com>
	<52CE78EB.60108@mellanox.com>
Date: Fri, 10 Jan 2014 15:39:21 -0500
In-Reply-To: <52CE78EB.60108@mellanox.com> (Sagi Grimberg's message of "Thu, 9
	Jan 2014 12:24:43 +0200")
Message-ID: <yq1mwj3r2py.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sagi" == Sagi Grimberg <sagig@mellanox.com> writes:

Sagi> What about FORMAT_UNIT emulation?  The backstore protection
Sagi> configuration is done at the target side via configfs/targetcli,

I don't know of any non-disk devices that actually implement FORMAT
UNIT. Usually such configuration is done using the array management
interface.

-- 
Martin K. Petersen	Oracle Linux Engineering
