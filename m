Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbbAFVyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:54:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299AbbAFVyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:54:18 -0500
Date: Tue, 6 Jan 2015 23:54:11 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v2 00/40] uaccess: fix sparse warning on get/put_user for
 bitwise types
Message-ID: <20150106215410.GA22927@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
 <4461163.Sc5FsMDTBa@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4461163.Sc5FsMDTBa@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 08:08:57PM +0100, Arnd Bergmann wrote:
> On Tuesday 06 January 2015 17:43:28 Michael S. Tsirkin wrote:
> > 
> > I tested this on x86 only. Since it's just adding __force, should be
> > trivially safe everywhere?
> > 
> > 
> > Arnd, did you merge v1 already? If yes, can you please replace with
> > this version?
> > 
> 
> I haven't merged it yet. I see that more Acks and some comments are
> coming in. Once those are done, could you send a pull request?

Sure. So I'll wait some then send you a pull request and you'll merge?

> It
> might be useful to have a branch that can be shared with architecture
> trees if necessary to avoid merge conflicts.
> 
> 	Arnd

In a couple of days, I'll put it on my linux-next branch and wait for
a bit. That will tell us whether there are any merge conflicts.

-- 
MSR
