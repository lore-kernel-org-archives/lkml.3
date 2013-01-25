Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945908Ab3AYKEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:04:39 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:56979 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755351Ab3AYKEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:04:37 -0500
Message-ID: <1359108275.6647.4.camel@x61.thuisdomein>
Subject: Re: [PATCH v3] lpc_ich: fix gpio base and control offsets
From: Paul Bolle <pebolle@tiscali.nl>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Aaron Sierra <asierra@xes-inc.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        =?ISO-8859-1?Q?Ag=F3cs_P=E1l?= <agocs.pal.86@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 25 Jan 2013 11:04:35 +0100
In-Reply-To: <CACRpkdZHndQsDZpn7BCFNXAO3k5vREYxDJkcYQ3_3sTbKAQLLA@mail.gmail.com>
References: <b9fec05c-d383-4282-b2af-c95855ff6abb@zimbra>
	 <3ffa5032-0565-48f0-a4ae-473452f4c902@zimbra>
	 <CACRpkdZHndQsDZpn7BCFNXAO3k5vREYxDJkcYQ3_3sTbKAQLLA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 25 Jan 2013 10:04:35.0796 (UTC) FILETIME=[61253140:01CDFAE3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-25 at 10:47 +0100, Linus Walleij wrote:
> On Thu, Jan 24, 2013 at 9:52 PM, Aaron Sierra <asierra@xes-inc.com> wrote:
> > In ICH5 and earlier the GPIOBASE and GPIOCTRL registers are found at
> > offsets 0x58 and 0x5C, respectively. This patch allows GPIO access to
> > properly be enabled (and disabled) for these chipsets.
> >
> > Signed-off-by: Agócs Pál <agocs.pal.86@gmail.com>
> > Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
> 
> OK... Paul, can you test this on your setup?

This seems to be the first time I'm added to this thread. I'm a bit lost
here: why should I test this patch? This doesn't seem to be related to
two older lpc_ich threads I was involved in (in November 2012). Not that
I mind testing stuff, that's not the problem...


Paul Bolle

