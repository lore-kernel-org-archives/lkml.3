Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbaAJG67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 01:58:59 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:60650 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaAJG64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 01:58:56 -0500
Message-ID: <1389337238.5567.408.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 09/14] target/configfs: Expose protection device
 attributes
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Sagi Grimberg <sagig@mellanox.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Or Gerlitz <ogerlitz@mellanox.com>
Date: Thu, 09 Jan 2014 23:00:38 -0800
In-Reply-To: <52CE817B.9070203@mellanox.com>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	 <1389212157-14540-10-git-send-email-nab@daterainc.com>
	 <52CE817B.9070203@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-09 at 13:01 +0200, Sagi Grimberg wrote:
> On 1/8/2014 10:36 PM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > This patch adds support for exposing DIF protection device
> > attributes via configfs.  This includes:
> >
> >     pi_prot_type: Protection Type (0, 1, 3 currently support)
> >     pi_prot_version: Protection Version (DIF v1 currently supported)
> >     pi_guard_type: Guard Type (1=DIF CRC, 2=IP CRC)
> >
> > Within se_dev_set_pi_prot_type() it also adds the se_subsystem_api
> > device callbacks to setup per device protection information.
> 
> Suggestion, expose pi_prot_format and call transport->init_prot() there. 
> It is more explicit
> and this routine should be called upon getting FORMAT_UNIT as well.

<nod>, working on this next for FILEIO following your original example
code.

Thanks Sagi!

--nab

