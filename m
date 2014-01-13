Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbaAMUYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:24:09 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45988 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751584AbaAMUYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:24:07 -0500
Message-ID: <1389644643.12062.42.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 09/14] target/configfs: Expose protection device
 attributes
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
Date: Mon, 13 Jan 2014 12:24:03 -0800
In-Reply-To: <yq1a9ezocrg.fsf@sermon.lab.mkp.net>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	 <1389212157-14540-10-git-send-email-nab@daterainc.com>
	 <yq161prr1p8.fsf@sermon.lab.mkp.net>
	 <1389637859.5567.431.camel@haakon3.risingtidesystems.com>
	 <1389639177.12062.21.camel@dabdike.int.hansenpartnership.com>
	 <1389641243.5567.445.camel@haakon3.risingtidesystems.com>
	 <yq1a9ezocrg.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-13 at 15:19 -0500, Martin K. Petersen wrote:
> >>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:
> 
> >> What proposed 16 byte scheme?  The only DIF proposals I know for
> >> SBC-4 are 13-185R0 and 12-369R0 and that's a couple of new algorithms
> >> and types because we cannot change the 8 byte PI.
> 
> nab> Then I'm probably getting the SBC version wrong..  It's the one
> nab> that includes using CRC32C for the block guard, and larger space
> nab> for reference tag as mentioned by MKP.
> 
> This is the Type 4 we have been shopping among various vendors. It
> predates and is simpler than HP's proposal (which met resistance in T10
> and was subsequently dropped). So we revived our original Type 4
> proposal which is 16 bytes of protection information per interval
> (CRC32C, 48-bit LBA and 6 bytes of app tag). The proposal has been
> sitting around for a while waiting for SBC-4 to open.

I'm intrigued by this: how do you get the extra space, since I heard all
the drive vendors were adamant that 520 was it for the current
manufacturing processes.

James


