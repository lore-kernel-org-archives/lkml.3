Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbaIDThz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 15:37:55 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:65092 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754688AbaIDThx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 15:37:53 -0400
Message-ID: <1409859471.5546.110.camel@x220>
Subject: Re: [PATCH] eeepc-laptop: remove possible use of uninitialized value
From: Paul Bolle <pebolle@tiscali.nl>
To: Frans Klaver <fransklaver@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@infradead.org>,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        acpi4asus-user <acpi4asus-user@lists.sourceforge.net>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Date: Thu, 04 Sep 2014 21:37:51 +0200
In-Reply-To: <CAH6sp9P3NJBFS=ewJnY3jVJc_dDf7LQs2TwYKZu7=bFhdAZXxg@mail.gmail.com>
References: <1409784805-14190-1-git-send-email-fransklaver@gmail.com>
	 <20140904004947.GA17138@vmdeb7> <20140904011420.GA31350@kroah.com>
	 <CAH6sp9OaqkdW82HOKMf8gxLLsBzXPCq2HYj7ya+C3YXiFwhgOQ@mail.gmail.com>
	 <20140904141041.GB23299@kroah.com>
	 <CAH6sp9P3NJBFS=ewJnY3jVJc_dDf7LQs2TwYKZu7=bFhdAZXxg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Sep 2014 19:37:51.0520 (UTC) FILETIME=[B7136A00:01CFC877]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-04 at 16:40 +0200, Frans Klaver wrote:
> I'll I fire up my eeepc and see what I can figure out. Should I take
> Pauls patch and see how it fits into this?

I haven't followed the conversation you're having with Greg, but I would
be grateful if you'd test _just_ my patch. Unless someone jumps in and
points to flaws in my patch, that is.

I suppose testing would mean writing some values to the related files
under /sys. I have no idea whatsoever what those files actually do, so
I'm afraid I can't tell you what values to write and what effects to
expect, sorry. Perhaps someone else can help you there.


Paul Bolle

