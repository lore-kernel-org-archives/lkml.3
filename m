Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaBYRnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 12:43:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193AbaBYRnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 12:43:24 -0500
Date: Tue, 25 Feb 2014 09:43:06 -0800
From: Jeff Layton <jlayton@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim McDonough <jmcd@samba.org>,
        David Disseldorp <ddiss@samba.org>, Steve French <smfrench@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Stable backport of cifs nlink workaround?
Message-ID: <20140225094306.63cccecb@corrin.poochiereds.net>
In-Reply-To: <20140225161156.GA27235@kroah.com>
References: <20140225152443.GA15552@sucs.org>
	<20140225161156.GA27235@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Feb 2014 08:11:56 -0800
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Tue, Feb 25, 2014 at 03:24:43PM +0000, Sitsofe Wheeler wrote:
> > Hi,
> > 
> > Is there any chance that 74d290da476f672ad756634d12aa707375d3564d
> > ([CIFS] Provide sane values for nlink) could be backported to the stable
> > 3.2 kernel?
> 
> Why just 3.2?  What's wrong with all of the other kernels before 3.12
> that do not have this patch in it?
> 
> thanks,
> 
> greg k-h

Yeah, you'd probably need to apply it to every stable kernel > 3.2 or
you'd technically have a regression. I've no real objection to putting
that fix in, but backporting to older kernels may not be trivial. There
have been other changes in this area over the years...

-- 
Jeff Layton <jlayton@redhat.com>
