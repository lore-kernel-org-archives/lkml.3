Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568AbaKUREU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:04:20 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:49561 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758926AbaKURES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:04:18 -0500
Message-ID: <546F7077.4010200@oracle.com>
Date: Fri, 21 Nov 2014 12:03:51 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Herrmann <dh.herrmann@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, ebiederm@xmission.com,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux API <linux-api@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Daniel Mack <daniel@zonque.org>, Djalal Harouni <tixxdz@opendz.org>
Subject: Re: kdbus: add node and filesystem implementation
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org> <1416546149-24799-7-git-send-email-gregkh@linuxfoundation.org> <546F606D.40407@oracle.com> <CANq1E4QkXv9Ak6eT+NZPsy+5nTGKE8oypLvdr97cFcvmtigS_A@mail.gmail.com> <20141121165638.GA24866@kroah.com>
In-Reply-To: <20141121165638.GA24866@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2014 11:56 AM, Greg Kroah-Hartman wrote:
>>> Maybe it's worth basing your git tree on top of Al's rather than a random
>>> > > -rc, since it's now a filesystem?
>> > 
>> > Sure, sounds good.
> No, I'll keep it as is, we can handle the merge issues later when it
> hits Linus's tree, this makes it easier for me and others to test it
> out properly.

It should be hitting -next, not Linus's tree. This is why we have an
integration tree, no?


Thanks,
Sasha
