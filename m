Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaAPHqB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 02:46:01 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:60837 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751545AbaAPHp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 02:45:59 -0500
Message-ID: <52D78E2C.70704@mellanox.com>
Date: Thu, 16 Jan 2014 09:45:48 +0200
From: sagi grimberg <sagig@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH 00/14] target: Initial support for DIF Type1+Type3 emulation
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>	<52D6CD70.20706@mellanox.com>	<1389822920.5567.560.camel@haakon3.risingtidesystems.com> <yq1wqi0wvm4.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1wqi0wvm4.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.0.13.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/16/2014 3:42 AM, Martin K. Petersen wrote:
>>>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:
> nab> The issue is that existing fs/bio-integrity.c code always assumes
> nab> client/initiator mode, in that it will attempt to
> nab> bio_integrity_generate() protection information in the submit_bio
> nab> WRITE path, and bio_integrity_verify() of protection information in
> nab> the bio_endio READ completion path.
>
> Only if the submit_bio() caller hasn't attached protection information
> already. If you submit a bio with a bip already attached the block layer
> will not generate/verify.
>

Yes, that was my understanding as well.

Thanks Martin,

Sagi.
