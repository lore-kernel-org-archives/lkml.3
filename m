Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab3A1Ll3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:41:29 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:50000 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757274Ab3A1Ll0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:41:26 -0500
Message-ID: <1359373280.1345.5.camel@x61.thuisdomein>
Subject: Re: [PATCH v3] lpc_ich: fix gpio base and control offsets
From: Paul Bolle <pebolle@tiscali.nl>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Aaron Sierra <asierra@xes-inc.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        =?ISO-8859-1?Q?Ag=F3cs_P=E1l?= <agocs.pal.86@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 28 Jan 2013 12:41:20 +0100
In-Reply-To: <1359120339.883.4.camel@x61.thuisdomein>
References: <b9fec05c-d383-4282-b2af-c95855ff6abb@zimbra>
	 <3ffa5032-0565-48f0-a4ae-473452f4c902@zimbra>
	 <CACRpkdZHndQsDZpn7BCFNXAO3k5vREYxDJkcYQ3_3sTbKAQLLA@mail.gmail.com>
	 <1359108275.6647.4.camel@x61.thuisdomein>
	 <CACRpkdb0V=yasmJv1ygL7cq6G3uGf6+QAZ7GR5a3bb1-XJgiiA@mail.gmail.com>
	 <1359115232.6647.14.camel@x61.thuisdomein>
	 <CACRpkdbUU=TOeaHNwAw-=iTxtkQDNuS4KeVBFX4yirZa+fQ2uw@mail.gmail.com>
	 <1359120339.883.4.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2013 11:41:20.0766 (UTC) FILETIME=[646A91E0:01CDFD4C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-25 at 14:25 +0100, Paul Bolle wrote:
> 1) Should I try booting with the updated module too?

Booting turned out to be a non-issue. I use lpc_ich as a module (Fedora
17 default) and lpc_ich isn't included by default in Fedora 17's
initramfs. So booting v3.7.5 with an updated module should hardly differ
from insmod'ing manually. And indeed, booting that way didn't lead to
any obvious issues.


Paul Bolle

