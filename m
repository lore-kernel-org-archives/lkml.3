Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaFFD0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 23:26:15 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:34398 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaFFD0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 23:26:14 -0400
Message-ID: <1402025169.5458.124.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: Change in security maintainer for a few weeks
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Date: Thu, 05 Jun 2014 23:26:09 -0400
In-Reply-To: <CACE9dm8bSo5FD7_hSVjfgkwp3xR06hL+y7EWvhv9nyEssFO4dw@mail.gmail.com>
References: <20140605183050.GA5054@kroah.com>
	 <CACE9dm8bSo5FD7_hSVjfgkwp3xR06hL+y7EWvhv9nyEssFO4dw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060603-1542-0000-0000-0000025F965D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-05 at 22:52 +0300, Dmitry Kasatkin wrote: 
> On 5 June 2014 21:30, Greg KH <gregkh@linuxfoundation.org> wrote:
> > Hi all,
> >
> > James has had to step back from doing kernel work for a few weeks, so
> > I've offered to step up and handle the security patches to get shuttled
> > to Linus for merging for a while.
> >
> > I'll take his git tree on kernel.org and push those to Linus for
> > 3.16-rc1, as those look like they have had proper testing in linux-next.
> >
> > But there only seems to be 14 patches in there.  Are there pending
> > patches that people have been sending and need to get in besides those?
> >
> > thanks,
> >
> 
> Hi Greg,
> 
> Mimi sent pull request to James last week without any response...
> 
> But that is based on James' 3.14 tree..
> May be Mimi need to rebase and send pull request to you..

I'm really sorry Dmitry.  Unlike the SELinux patches, the integrity
patches didn't make it into linux-next.  Based on Paul's suggestion,
I'll request that the linux-integrity tree be added to the list of trees
that are pulled directly into linux-next, instead of waiting for it to
go in via the security tree.

Mimi

