Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763190Ab3DDV7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 17:59:50 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:55502 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760720Ab3DDV7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 17:59:47 -0400
Subject: Re: [RFC-v3 9/9] iser-target: Add iSCSI Extensions for RDMA (iSER)
 target driver
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Or Gerlitz <ogerlitz@mellanox.com>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Roland Dreier <roland@kernel.org>,
        Alexander Nezhinsky <alexandern@mellanox.com>
In-Reply-To: <515D45F6.9040903@mellanox.com>
References: <1365060256-21506-1-git-send-email-nab@linux-iscsi.org>
	 <1365060256-21506-10-git-send-email-nab@linux-iscsi.org>
	 <515D45F6.9040903@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Apr 2013 14:59:44 -0700
Message-ID: <1365112784.11833.60.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-04 at 12:20 +0300, Or Gerlitz wrote:
> On 04/04/2013 10:24, Nicholas A. Bellinger wrote:
> > +
> > +void isert_cq_tx_callback(struct ib_cq *, void *);
> > +void isert_cq_rx_callback(struct ib_cq *, void *);
> > +void isert_free_rx_descriptors(struct isert_conn *);
> any reason not to have these as static functions (same for isert_cq_rx_work)

Nope.  Looking at re-orig now to avoid the use of function prototypes
here, and marking everything as static..

--nab

