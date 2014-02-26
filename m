Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbaBZBVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 20:21:05 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:39287 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaBZBVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:21:01 -0500
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagig@mellanox.com>
Subject: Re: [RFC 0/6] vhost/scsi: Add T10 PI SGL passthrough support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1393219950-18613-1-git-send-email-nab@daterainc.com>
	<530B1DAF.7010702@redhat.com>
	<1393308311.12334.14.camel@haakon3.risingtidesystems.com>
Date: Tue, 25 Feb 2014 20:20:42 -0500
In-Reply-To: <1393308311.12334.14.camel@haakon3.risingtidesystems.com>
	(Nicholas A. Bellinger's message of "Mon, 24 Feb 2014 22:05:11 -0800")
Message-ID: <yq1y50yhdp1.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:

nab> Mmm, at least for PI I don't think a residual field is necessary.

nab> Any time the metadata is not fully read on outgoing WRITEs, or
nab> written on incoming READs the next hop performing a VERIFY
nab> operation will end up failing with a GUARD or REFERENCE TAG
nab> failure.

nab> MKP..?

Yeah, that should be OK.

-- 
Martin K. Petersen	Oracle Linux Engineering
