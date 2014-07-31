Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbaGaRtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:49:14 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:54686 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaGaRtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:49:13 -0400
MIME-Version: 1.0
In-Reply-To: <E1XCr4p-0007Nh-Qu@lists.xen.org>
References: <E1XCqEY-0005zn-RQ@lists.xen.org>
	<1406814787.10395.2.camel@kazak.uk.xensource.com>
	<E1XCr4p-0007Nh-Qu@lists.xen.org>
Date: Thu, 31 Jul 2014 13:49:10 -0400
X-Google-Sender-Auth: tGArzTdRe3dDgoG228P2hg9HmHg
Message-ID: <CAFLBxZYnaeEGTbuU5QoKJOU62Ck9p_B53bjAd46Z7uVgOxXH8g@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH 1/2] xen: Implement ioctl to restrict privcmd
 to a specific domain
From: George Dunlap <George.Dunlap@eu.citrix.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        Frediano Ziglio <frediano.ziglio@citrix.com>,
        xen-devel <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-api@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 10:11 AM, David Vrabel <david.vrabel@citrix.com> wrote:
> On 31/07/14 14:53, Ian Campbell wrote:
>> On Thu, 2014-07-31 at 14:16 +0100, Frediano Ziglio wrote:
>>
>>>  include/xen/interface/domctl.h     | 1090 ++++++++++++++++++++++++++++++++++++
>>
>> domctl is an stable toolstack only hypervisor interface, so the kernel
>> cannot use it because it would then break.
>
> Ok.  I guess we'll have to resurrect the idea to do something with XSM.

What kind of thing did you have in mind for XSM?

In general it seems like allowing a vcpu to switch into an XSM label
(not sure I've got the terminology right here) when it context
switches into a particular process might be the most flexible way for
that to work.

But would that actually be easier than implementing stub domains?

 -George
