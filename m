Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab3EVSqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 14:46:12 -0400
Received: from plane.gmane.org ([80.91.229.3]:35639 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432Ab3EVSpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 14:45:53 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Michael =?UTF-8?B?R3Jvw59ow6R1c2Vy?= 
	<michael.grosshaeuser@t-online.de>
Subject: Re: Fans at full speed after resume
Date: Wed, 22 May 2013 20:46:53 +0200
Message-ID: <knj3oe$h88$1@ger.gmane.org>
References: <CAPz6YkWr_D504UdeqXB0FXxgqOt3GYnF09ctoMaZ8P-znbVMGQ@mail.gmail.com> <1368591999.5890.9.camel@rzhang1-mobl4> <1368592193.5890.10.camel@rzhang1-mobl4>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p5ddcb680.dip0.t-ipconnect.de
User-Agent: KNode/4.10.3
Cc: linux-pm@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang Rui wrote:

> On Wed, 2013-05-15 at 12:26 +0800, Zhang Rui wrote:
>> please
>> 
>> On Tue, 2013-05-14 at 21:18 -0700, Sonny Rao wrote:
>> > Hi, I've seen a regression in kernels since 3.7 on x86 devices where
>> > the kernel turns the system fans on to max speed after resuming from
>> > ram.  Other people have noticed it as well, for example see
>> > https://bugzilla.redhat.com/show_bug.cgi?id=895276
>> > 
>> please check if this is a duplicate of bug
>> https://bugzilla.kernel.org/show_bug.cgi?id=56591
> or you can try 3.10-rc1 to see if the problem still exists or not.
> 
> thanks,
> rui


Hi,

I can confirm the same problem on a HP/Compaq 2510p with 3.10-rc2.

Best Regards,
Michael

