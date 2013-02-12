Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450Ab3BLTdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 14:33:03 -0500
Received: from ns1.siteground186.com ([184.154.229.6]:35200 "EHLO
	serv01.siteground186.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933170Ab3BLTdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 14:33:00 -0500
X-Greylist: delayed 6573 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Feb 2013 14:32:59 EST
Message-ID: <511A7F2B.20308@reliableembeddedsystems.com>
Date: Tue, 12 Feb 2013 19:43:07 +0200
From: Robert Berger <gmane@reliableembeddedsystems.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.arm
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-arm@vger.kernel.org
Subject: gcov/lkm/arm-eabi/gcc 4.7.2 issue
References: <1338334286.2658.536.camel@shawn-ssd> <CAJfuBxweY7sG2KZDPHsrOP6iu8sQxw8EvCKA1QtGnDFKA92zag@mail.gmail.com> <1338342203.2658.544.camel@shawn-ssd> <CAJfuBxwP_p4Y4pp50qfEts4zoOkJ16Hj_Yu68q3qd7=5UMLeiw@mail.gmail.com> <1338387021.23168.18.camel@shawn-ssd> <CAJfuBxxkMJbmvQMCZx=6GUqJ8c6VnT8jaRTKA-OWZLa0gG7kUw@mail.gmail.com> <1338406801.23168.74.camel@shawn-ssd> <20120530203428.GB16686@redhat.com>
In-Reply-To: <20120530203428.GB16686@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground186.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - reliableembeddedsystems.com
X-Get-Message-Sender-Via: serv01.siteground186.com: none
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There seems to be an issue with gcov on kernel modules if you have an
arm-eabi gcc on Linux 3.8-rc6 and previous versions.

./arm-linux-gnueabi-gcc --version
arm-linux-gnueabi-gcc (GCC) 4.7.2

I followed these instructions [1], but without much success.

In case I compile an out of tree kernel module with gcov enabled it can
not be loaded and issues the following error: "unknown relocation: 38"

I tried this patch [2] as well without success. It loads now, but still
nothing useful in /sys/kernel/debug/gcov

Please advise,

Regards,

Robert

[1]
http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=blob;f=Documentation/gcov.txt;h=e7ca6478cd93d4e6422d1ae92455b347dbdf7ccb;hb=HEAD

[2]
http://us.generation-nt.com/answer/add-gcov-support-arm-help-207630451.html

My public pgp key is available,at:
http://pgp.mit.edu:11371/pks/lookup?op=get&search=0x90320BF1


..."C treats you like a consenting adult. Pascal treats you like a
naughty child. Ada treats you like a criminal." -- (Bruce Powel Douglass)

My public pgp key is available,at:
http://pgp.mit.edu:11371/pks/lookup?op=get&search=0x90320BF1

