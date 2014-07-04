Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157AbaGDWFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:05:51 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:63486 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753622AbaGDWFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:05:50 -0400
Message-ID: <1404511548.18844.3.camel@x220>
Subject: Re: Qualcomm "All Rights Reserved" in Linux staging
From: Paul Bolle <pebolle@tiscali.nl>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: gregkh <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>
Date: Sat, 05 Jul 2014 00:05:48 +0200
In-Reply-To: <1983136768.8892.1404508828693.JavaMail.zimbra@efficios.com>
References: <1983136768.8892.1404508828693.JavaMail.zimbra@efficios.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jul 2014 22:05:48.0948 (UTC) FILETIME=[1CD2ED40:01CF97D4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-04 at 21:20 +0000, Mathieu Desnoyers wrote:
> grep -r "Qualcomm" . |grep -i "rights"
> ./drivers/staging/ft1000/ft1000-usb/ft1000_usb.c: * CopyRight (C) 2007 Qualcomm Inc. All Rights Reserved.
> ./drivers/staging/ft1000/ft1000-usb/ft1000_download.c:* CopyRight (C) 2007 Qualcomm Inc. All Rights Reserved.
> ./drivers/staging/ft1000/ft1000-usb/ft1000_hw.c:/* CopyRight (C) 2007 Qualcomm Inc. All Rights Reserved.

That's actually a common pattern:
    $ git grep -i "Copyright.*All Rights Reserved" v3.16-rc3 | wc -l
    5203


Paul Bolle

