Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaAMUI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:08:59 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:17549 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaAMUIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:08:55 -0500
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH 14/14] tcm_loop: Enable DIF/DIX modes in SCSI host LLD
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	<1389212157-14540-15-git-send-email-nab@daterainc.com>
	<yq1wqi7pmrd.fsf@sermon.lab.mkp.net>
	<1389638711.5567.437.camel@haakon3.risingtidesystems.com>
Date: Mon, 13 Jan 2014 15:08:37 -0500
In-Reply-To: <1389638711.5567.437.camel@haakon3.risingtidesystems.com>
	(Nicholas A. Bellinger's message of "Mon, 13 Jan 2014 10:45:11 -0800")
Message-ID: <yq1ha97oda2.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:

nab> Sure, this can be exposed at a tcm_loop configfs attribute that is
nab> accessible after scsi_add_host() has been called, which I assume is
nab> OK to do..

As long as it's set before we discover devices.

-- 
Martin K. Petersen	Oracle Linux Engineering
