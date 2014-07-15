Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbaGOIls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 04:41:48 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:60256 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaGOIlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 04:41:46 -0400
References: <53C4E2F0.8000307@linux.vnet.ibm.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <53C4E2F0.8000307@linux.vnet.ibm.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E83EB052-8DC9-4B0E-830D-AF7A2557BEF6@kernel.dk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mlombard@redhat.com" <mlombard@redhat.com>,
        "ming.lei@canonical.com" <ming.lei@canonical.com>,
        "dongsu.park@profitbricks.com" <dongsu.park@profitbricks.com>,
        "jet.chen@intel.com" <jet.chen@intel.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "hch@lst.de" <hch@lst.de>, "kmo@daterainc.com" <kmo@daterainc.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "axboe@fb.com" <axboe@fb.com>
X-Mailer: iPhone Mail (11D257)
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Bug_ON with patch: bio: modify __bio_add_page() to accept pages that don't start a new segment
Date: Tue, 15 Jul 2014 10:41:40 +0200
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/07/2014, at 10.14, Mike Qiu <qiudayu@linux.vnet.ibm.com> wrote:
> 
> My Power7 box boot fail with commit:
> 
> 254c4407cb84a6dec90336054615b0f0e996bb7c
> bio: modify __bio_add_page() to accept pages that don't start a new segment
> 
> Just revert it will works for me.

I have reverted it yesterday in my tree. 

