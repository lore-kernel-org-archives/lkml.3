Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751170AbaKURzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:55:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaKURzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:55:39 -0500
Date: Fri, 21 Nov 2014 09:55:38 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: David Herrmann <dh.herrmann@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        ebiederm@xmission.com,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux API <linux-api@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Daniel Mack <daniel@zonque.org>, Djalal Harouni <tixxdz@opendz.org>
Subject: Re: kdbus: add node and filesystem implementation
Message-ID: <20141121175538.GA27698@kroah.com>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
 <1416546149-24799-7-git-send-email-gregkh@linuxfoundation.org>
 <546F606D.40407@oracle.com>
 <CANq1E4QkXv9Ak6eT+NZPsy+5nTGKE8oypLvdr97cFcvmtigS_A@mail.gmail.com>
 <20141121165638.GA24866@kroah.com>
 <546F7077.4010200@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546F7077.4010200@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 12:03:51PM -0500, Sasha Levin wrote:
> On 11/21/2014 11:56 AM, Greg Kroah-Hartman wrote:
> >>> Maybe it's worth basing your git tree on top of Al's rather than a random
> >>> > > -rc, since it's now a filesystem?
> >> > 
> >> > Sure, sounds good.
> > No, I'll keep it as is, we can handle the merge issues later when it
> > hits Linus's tree, this makes it easier for me and others to test it
> > out properly.
> 
> It should be hitting -next, not Linus's tree. This is why we have an
> integration tree, no?

Yes, it will hit -next, and the merge issue can be resolved there.
