Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871Ab3DDJg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:36:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41902 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758844Ab3DDJg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:36:58 -0400
MIME-Version: 1.0
In-Reply-To: <20130403160811.GA21383@kroah.com>
References: <1364957903-10341-1-git-send-email-ming.lei@canonical.com>
	<20130403030403.GA26913@redhat.com>
	<CACVXFVPOC=d3-1UBu6UbqJXMS2gG=DXnBJeuLaFc3R4QKAzWyg@mail.gmail.com>
	<20130403053534.GA8091@kroah.com>
	<CACVXFVMV6cFhrybrE_oNSthzPF71xOE7dbwTK9GP+x08d3TpQA@mail.gmail.com>
	<20130403160811.GA21383@kroah.com>
Date: Thu, 4 Apr 2013 17:36:55 +0800
Message-ID: <CACVXFVOYFihy6OrVkRPnx1tk5bDxBvdu=B3-ghbjZ_+bww2=qQ@mail.gmail.com>
Subject: Re: [PATCH] sysfs: check if one entry has been removed before freeing
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 12:08 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> Then make it a WARN() call, like David said, to give us a chance to get
> the report from a user so we can fix it.  If the machine crashes after
> that, fine, but hopefully we will get a oops report out of it.

OK, got it, and console might not be available at that time.


Thanks,
--
Ming Lei
