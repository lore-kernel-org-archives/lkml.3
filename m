Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab3A1LpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:45:11 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:55460 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754134Ab3A1LpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:45:08 -0500
Message-ID: <1359373506.1345.9.camel@x61.thuisdomein>
Subject: Re: [PATCH v3] lpc_ich: fix gpio base and control offsets
From: Paul Bolle <pebolle@tiscali.nl>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Aaron Sierra <asierra@xes-inc.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        =?ISO-8859-1?Q?Ag=F3cs_P=E1l?= <agocs.pal.86@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 28 Jan 2013 12:45:06 +0100
In-Reply-To: <CACRpkdYV3KGz45Ko1n-QJ6VQ4Y8SAb3zd87AvfpP1TSUAh=FsQ@mail.gmail.com>
References: <b9fec05c-d383-4282-b2af-c95855ff6abb@zimbra>
	 <3ffa5032-0565-48f0-a4ae-473452f4c902@zimbra>
	 <CACRpkdZHndQsDZpn7BCFNXAO3k5vREYxDJkcYQ3_3sTbKAQLLA@mail.gmail.com>
	 <20130125164800.GB1174@sortiz-mobl>
	 <CACRpkdYV3KGz45Ko1n-QJ6VQ4Y8SAb3zd87AvfpP1TSUAh=FsQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2013 11:45:07.0122 (UTC) FILETIME=[EB55C120:01CDFD4C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-28 at 11:11 +0100, Linus Walleij wrote:
> OK cool, I think we can conclude that this patch is fine after the
> boot tests and all:
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
 
In case this ACK requires my feedback: I just reported that booting
v3.7.5 with an updated lpc_ich module didn't lead to any obvious issues.


Paul Bolle

