Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab3CNWMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:12:32 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:62156 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753188Ab3CNWM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:12:26 -0400
Message-ID: <1363299141.1335.88.camel@x61.thuisdomein>
Subject: Re: [PATCH] staging: ccg: remove two outdated dependencies
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Thu, 14 Mar 2013 23:12:21 +0100
In-Reply-To: <20130314220229.GA7991@kroah.com>
References: <1363256224.1335.46.camel@x61.thuisdomein>
	 <20130314105953.GJ9138@mwanda> <1363259393.1335.55.camel@x61.thuisdomein>
	 <20130314220229.GA7991@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Mar 2013 22:12:21.0834 (UTC) FILETIME=[FFF5D2A0:01CE2100]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-14 at 15:02 -0700, Greg Kroah-Hartman wrote:
> On Thu, Mar 14, 2013 at 12:09:53PM +0100, Paul Bolle wrote:
> > Well, now that you somehow managed to review this patch the urge to
> > clean this line up has suddenly diminished. But maybe you're lucky and
> > this will not pass Greg. 
> 
> It didn't, please clean it up "properly", I'll drop this patch for now,
> thanks. :)

The horror is mostly caused by negative dependencies on USB Kconfig
symbols. Any clue why this driver conflicts with about twenty USB
related options?


Paul Bolle

