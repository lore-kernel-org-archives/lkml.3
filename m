Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaFETwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 15:52:45 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:44374 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaFETwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 15:52:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140605183050.GA5054@kroah.com>
References: <20140605183050.GA5054@kroah.com>
Date: Thu, 5 Jun 2014 22:52:42 +0300
Message-ID: <CACE9dm8bSo5FD7_hSVjfgkwp3xR06hL+y7EWvhv9nyEssFO4dw@mail.gmail.com>
Subject: Re: Change in security maintainer for a few weeks
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 June 2014 21:30, Greg KH <gregkh@linuxfoundation.org> wrote:
> Hi all,
>
> James has had to step back from doing kernel work for a few weeks, so
> I've offered to step up and handle the security patches to get shuttled
> to Linus for merging for a while.
>
> I'll take his git tree on kernel.org and push those to Linus for
> 3.16-rc1, as those look like they have had proper testing in linux-next.
>
> But there only seems to be 14 patches in there.  Are there pending
> patches that people have been sending and need to get in besides those?
>
> thanks,
>

Hi Greg,

Mimi sent pull request to James last week without any response...

But that is based on James' 3.14 tree..
May be Mimi need to rebase and send pull request to you..

Thanks,

- Dmitry

> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,
Dmitry
