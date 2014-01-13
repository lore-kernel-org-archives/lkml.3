Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaAMSxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 13:53:01 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45463 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751893AbaAMSw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 13:52:59 -0500
Message-ID: <1389639177.12062.21.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 09/14] target/configfs: Expose protection device
 attributes
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
Date: Mon, 13 Jan 2014 10:52:57 -0800
In-Reply-To: <1389637859.5567.431.camel@haakon3.risingtidesystems.com>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	 <1389212157-14540-10-git-send-email-nab@daterainc.com>
	 <yq161prr1p8.fsf@sermon.lab.mkp.net>
	 <1389637859.5567.431.camel@haakon3.risingtidesystems.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-13 at 10:30 -0800, Nicholas A. Bellinger wrote:
> Hey MKP,
> 
> On Fri, 2014-01-10 at 16:01 -0500, Martin K. Petersen wrote:
> > >>>>> "nab" == Nicholas A Bellinger <nab@daterainc.com> writes:
> > 
> > nab> This patch adds support for exposing DIF protection device
> > nab> attributes via configfs.  This includes:
> > 
> > nab>    pi_prot_type: Protection Type (0, 1, 3 currently support)
> > nab>    pi_prot_version: Protection Version (DIF v1 currently supported)
> > 
> > What's DIF v2?
> > 
> 
> This would be the proposed 16-byte protection scheme for SBC4.

What proposed 16 byte scheme?  The only DIF proposals I know for SBC-4
are 13-185R0 and 12-369R0 and that's a couple of new algorithms and
types because we cannot change the 8 byte PI.

James


