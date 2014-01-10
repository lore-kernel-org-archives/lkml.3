Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbaAJUk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 15:40:58 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27648 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758109AbaAJUky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 15:40:54 -0500
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Sagi Grimberg <sagig@mellanox.com>,
        "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH 07/14] target/sbc: Add P_TYPE + PROT_EN bits to READ_CAPACITY_16
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	<1389212157-14540-8-git-send-email-nab@daterainc.com>
	<52CE78EB.60108@mellanox.com>
	<1389334891.5567.373.camel@haakon3.risingtidesystems.com>
Date: Fri, 10 Jan 2014 15:40:37 -0500
In-Reply-To: <1389334891.5567.373.camel@haakon3.risingtidesystems.com>
	(Nicholas A. Bellinger's message of "Thu, 09 Jan 2014 22:21:31 -0800")
Message-ID: <yq1iotrr2nu.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:

>> The backstore protection configuration is done at the target side via
>> configfs/targetcli, if you publish DIF support in
>> INQUERY_EVPD/READ_CAPACITY you need to accept protection information
>> format?

nab> Mmmm, these two bits bits are following what scsi_debug is
nab> currently exposing minus FORMAT_UNIT support..?

PROT_EN and P_TYPE should be fine for now.

-- 
Martin K. Petersen	Oracle Linux Engineering
