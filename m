Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbaA2C20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 21:28:26 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20382 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbaA2C2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 21:28:24 -0500
Date: Tue, 28 Jan 2014 18:28:16 -0800
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: roger.pau@citrix.com, Xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [V0 PATCH] pvh: Disable PSE feature for now
Message-ID: <20140128182816.3ef321d1@mantra.us.oracle.com>
In-Reply-To: <20140128034634.GC20680@pegasus.dumpdata.com>
References: <1390875519-8667-1-git-send-email-mukesh.rathor@oracle.com>
	<1390875519-8667-2-git-send-email-mukesh.rathor@oracle.com>
	<20140128034634.GC20680@pegasus.dumpdata.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jan 2014 22:46:34 -0500
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> On Mon, Jan 27, 2014 at 06:18:39PM -0800, Mukesh Rathor wrote:
> > Until now, xen did not expose PSE to pvh guest, but a patch was
> > submitted to xen list to enable bunch of features for a pvh guest.
> > PSE has not been
> 
> Which 'patch'?
> 
> > looked into for PVH, so until we can do that and test it to make
> > sure it works, disable the feature to avoid flood of bugs.
> 
> I think we want a flood of bugs, no?

Ok, but lets document (via this email :)), that they are not tested.

thanks
Mukesh
