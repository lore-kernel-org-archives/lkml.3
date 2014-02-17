Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbaBQUVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 15:21:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49043 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487AbaBQUVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 15:21:14 -0500
Date: Mon, 17 Feb 2014 21:21:10 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: KY Srinivasan <kys@microsoft.com>
cc: David Herrmann <dh.herrmann@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] HID: hyperv: make sure input buffer is big enough
In-Reply-To: <5bae77400133466d9698c925bfe58df5@BY2PR03MB299.namprd03.prod.outlook.com>
Message-ID: <alpine.LNX.2.00.1402172120560.1192@pobox.suse.cz>
References: <1387452744-8860-1-git-send-email-dh.herrmann@gmail.com> <5bae77400133466d9698c925bfe58df5@BY2PR03MB299.namprd03.prod.outlook.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013, KY Srinivasan wrote:

> > We need at least HID_MAX_BUFFER_SIZE (4096) bytes as input buffer. HID
> > core depends on this as it requires every input report to be at least as
> > big as advertised.
> > 
> > Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Now applied.

-- 
Jiri Kosina
SUSE Labs
