Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614AbaJNPAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 11:00:32 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:41840 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393AbaJNPA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 11:00:27 -0400
Message-ID: <D20BE99904464948A4436297B32F990E@local.st.by>
From: "Victor Miasnikov" <vvm@tut.by>
To: "Mike Surcouf" <mps.surcouf.lkml@gmail.com>,
        "Richard Cochran" <richardcochran@gmail.com>
Cc: "KY Srinivasan" <kys@microsoft.com>, <jasowang@redhat.com>,
        "\"Andy Whitcroft\"" <apw@canonical.com>, <olaf@aepfle.de>,
        <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        "Greg KH" <gregkh@linuxfoundation.org>, <tglx@linutronix.de>,
        "Thomas Shao" <huishao@microsoft.com>
References: <1413285078-7027-1-git-send-email-huishao@microsoft.com> <20141014115412.GC4019@localhost.localdomain> <CD2CABCB2C0A0D4682C5F8AD840141540BFD41@HKXPRD3002MB006.064d.mgd.msft.net> <20141014132551.GB5994@localhost.localdomain> <CAL7Bo8EHOgBFtE87ecC9PSwUy2=M5Q31ka6BX2Eut-eqXSbang@mail.gmail.com> <20141014143346.GC6469@localhost.localdomain>
Subject: Re: [PATCH 2/2] hyperv: Implement Time Synchronization using host time sample
Date: Tue, 14 Oct 2014 18:00:16 +0300
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.3790.4548
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>> VMware has put a lot of effort into host -> guest timesync so I think
>> there is a case for some form of host based time sync on HyperV.
  . . .
>
> IMHO, you should let the guest steer its own clock. 
> That gives the end user the most flexibility.


   No problem:

 Time Sync can be turn off in VM settings



Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/
