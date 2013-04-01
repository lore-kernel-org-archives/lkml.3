Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433Ab3DATbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 15:31:40 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:64452 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759394Ab3DATbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 15:31:39 -0400
Message-ID: <1364844698.21627.83.camel@x61.thuisdomein>
Subject: Re: [PATCH] [TRIVIAL] Remove obsolete, iSeries specific, Makefile
 lines
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 01 Apr 2013 21:31:38 +0200
In-Reply-To: <alpine.LNX.2.00.1303311746490.22069@pobox.suse.cz>
References: <1364568500.1345.78.camel@x61.thuisdomein>
	 <alpine.LNX.2.00.1303311746490.22069@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2013 19:31:38.0426 (UTC) FILETIME=[877A09A0:01CE2F0F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-03-31 at 17:47 +0200, Jiri Kosina wrote:
> I believe you could remove all the corresponding major number defines from 
> include/uapi/linux/major.h while you are at it.

0) You seem to mean these:
    $ grep VIO include/uapi/linux/major.h
    #define VIODASD_MAJOR		112
    #define VIOCD_MAJOR		113
    #define VIOTAPE_MAJOR		230

They are indeed unused. But are they safe to be removed? I'm always very
cautious with touching magic numbers, and the like (even obsolete).

1) Anyhow, if they really can be removed, I prefer to do that in a
separate patch.


Paul Bolle

