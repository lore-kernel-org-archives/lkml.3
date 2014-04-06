Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbaDFDyH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 23:54:07 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52071 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754090AbaDFDyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 23:54:00 -0400
X-Sasl-enc: jFtxXFV4P3QpGkSjbMcrOr8/EB6ZYnY7HvfKQXHwC5ev 1396756439
Message-ID: <1396756437.24991.6.camel@perseus.fritz.box>
Subject: Re: [PATCH] autofs4: check dev ioctl size before allocating
From: Ian Kent <raven@themaw.net>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        akpm@linux-foundation.org
Date: Sun, 06 Apr 2014 11:53:57 +0800
In-Reply-To: <5340C5C7.9010203@oracle.com>
References: <1394934021-16965-1-git-send-email-sasha.levin@oracle.com>
		 <53401C11.7010601@oracle.com> <1396753403.24991.3.camel@perseus.fritz.box>
	 <5340C5C7.9010203@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-04-05 at 23:11 -0400, Sasha Levin wrote:
> On 04/05/2014 11:03 PM, Ian Kent wrote:
> > On Sat, 2014-04-05 at 11:06 -0400, Sasha Levin wrote:
> >> Ping? Anyone wants to take this?
> > 
> > Is this causing a problem for users?
> > If it is I'll send it to Andrew straight away.
> > 
> > I do have this on my queue but don't have any other patches to send so
> > it's just sitting there.
> > 
> > If it worries you I'll send it to Andrew now.
> 
> It's not really a pressing issue since /dev/autofs is accessible only to
> root. I also doubt that it causes problems for actual users.
> 
> If there are no issues with the patch, I think it's best if you could
> ack/sign off on it and if Andrew wants to take it now, he could. If he
> doesn't, it could wait for whenever.
> 
> I just don't want it getting lost somewhere and never making it upstream.

OK, but since I'm going to send it I looked at it a bit closer.
Shouldn't the E2BIG be ENAMETOOLONG since it's a file path that's being
passed?

I can change that and send it if you agree with the change.

Ian

