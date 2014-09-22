Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbaIVVDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:03:12 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:50244 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbaIVVDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:03:10 -0400
Message-ID: <1411419788.24986.37.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 4/4] target: Add a user-passthrough backstore
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Andy Grover <agrover@redhat.com>
Cc: Alex Elsayed <eternaleye@gmail.com>, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Sep 2014 14:03:08 -0700
In-Reply-To: <54208E03.8030906@redhat.com>
References: <1410822750-10717-1-git-send-email-agrover@redhat.com>
	 <1410822750-10717-5-git-send-email-agrover@redhat.com>
	 <1411161279.23258.26.camel@haakon3.risingtidesystems.com>
	 <lvi81j$ud8$2@ger.gmane.org>
	 <1411169965.23258.45.camel@haakon3.risingtidesystems.com>
	 <lvifie$emi$3@ger.gmane.org> <541CCBD1.8050606@redhat.com>
	 <1411419532.24986.36.camel@haakon3.risingtidesystems.com>
	 <54208E03.8030906@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-22 at 14:00 -0700, Andy Grover wrote:
> On 09/22/2014 01:58 PM, Nicholas A. Bellinger wrote:
> > So I'd still like to start for an initial merge with the two different
> > modes mentioned earlier.  The pure-passthrough mode where everything is
> > handled by user-space, and an I/O passthrough mode where only
> > SCF_SCSI_DATA_CDB is passed along to userspace, but all other control
> > CDBs are handled by existing in-kernel emulation.
> >
> > Andy, can you re-spin a series with these two approaches in mind..?
> 
> Will do. This is actually close to what the initial RFC version I posted 
> did.
> 

Also, it would be nice to include the example user-space code that
proves the logic into the patch series, so it can be carried along with
kernel sources.

--nab

