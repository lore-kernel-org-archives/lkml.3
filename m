Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbaFEApH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:45:07 -0400
Received: from plane.gmane.org ([80.91.229.3]:45165 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbaFEApF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 20:45:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Valerio Vanni" <valerio@valeriovanni.com>
Subject: Re: [PATCH 2/2] serial: core: Preserve termios c_cflag for console resume
Date: Thu, 5 Jun 2014 01:31:43 +0200
Message-ID: <lmoa97$q3h$1@ger.gmane.org>
References: <7EC4C3FDEFF6492F91DEE16AEE0831E6@vanni.it> <1401891371-4946-1-git-send-email-peter@hurleysoftware.com> <1401891371-4946-2-git-send-email-peter@hurleysoftware.com> <20140604142232.GB1008@kroah.com> <538F3150.6040102@hurleysoftware.com>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 81-174-24-37.v4.ngi.it
X-Newsreader: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
X-RFC2646: Format=Flowed; Response
Cc: linux-serial@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Peter Hurley" <peter@hurleysoftware.com> ha scritto nel messaggio
news:538F3150.6040102@hurleysoftware.com
> On 06/04/2014 10:22 AM, Greg Kroah-Hartman wrote:
>> Same as before, regression, or just a normal "new feature"?
>
> This was reported as a regression since 2.6.24, but that was likely
> misreported, and more likely due to a userspace update which triggers
> the bug.
>
> I would be surprised if console resume _never_ worked if the serial
> tty was opened then closed, but it probably has worked for a long
> time.

I don't know what was my initial mistake, but I realized very soon it was 
not a regression and took away the "regression" flag from bugzilla.
I tried many and many kernels and all were failing. I tried also to go 
down from 2.6.24 version, but I had to stop rather early because at some 
point the kernels were incompatible with distribution (I don't remember 
the details since I did these tests some month ago, and later I tested 
only newer kernel versions).

The patches you sent are for -next? for -rc? for stable?
Can I try them on 3.13.11? (at the moment I'm using this) 



