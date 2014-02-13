Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbaBMKbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 05:31:14 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:64317 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823AbaBMKbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:31:12 -0500
Message-ID: <1392287466.30853.48.camel@x220>
Subject: Re: [PATCH] Blackfin: bf537: rename "CONFIG_ADT7310" and friends
From: Paul Bolle <pebolle@tiscali.nl>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Guenter Roeck <linux@roeck-us.net>, Steven Miao <realmz6@gmail.com>,
        adi-buildroot-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Feb 2014 11:31:06 +0100
In-Reply-To: <1392285474.30853.28.camel@x220>
References: <1364211831.1390.285.camel@x61.thuisdomein>
	 <20130325152258.GA17467@roeck-us.net> <51507126.2040002@metafoo.de>
	 <1392285474.30853.28.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Feb 2014 10:31:12.0042 (UTC) FILETIME=[B73500A0:01CF28A6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-13 at 10:57 +0100, Paul Bolle wrote:
> This issue is still present in v3.14-rc2. Guenter's suggestion is the
> easiest way out. Should I submit a trivial patch that just removes the
> dead code depending on never defined CONFIG_ADT7310 and
> CONFIG_ADT7310_MODULE?

And that is probably also true for for CONFIG_ADT7410 and
CONFIG_ADT7410_MODULE. See https://lkml.org/lkml/2013/5/13/497 (and my
follow up to that message).


Paul Bolle

