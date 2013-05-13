Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab3EMUOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 16:14:53 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:62903 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755244Ab3EMUOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 16:14:52 -0400
Message-ID: <1368476089.1350.74.camel@x61.thuisdomein>
Subject: Re: [PATCH] myri_sbus: remove firmware
From: Paul Bolle <pebolle@tiscali.nl>
To: David Miller <davem@davemloft.net>
Cc: mason@myri.com, linux-kernel@vger.kernel.org
Date: Mon, 13 May 2013 22:14:49 +0200
In-Reply-To: <20130513.130749.1053380556995548595.davem@davemloft.net>
References: <1365171782.1830.67.camel@x61.thuisdomein>
	 <20130405.125530.727706283199340601.davem@davemloft.net>
	 <1368475385.1350.70.camel@x61.thuisdomein>
	 <20130513.130749.1053380556995548595.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 May 2013 20:14:50.0556 (UTC) FILETIME=[85DB2FC0:01CE5016]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-13 at 13:07 -0700, David Miller wrote:
> From: Paul Bolle <pebolle@tiscali.nl>
> > I don't think this patch has been queued for mainline anywhere. Would
> > you mind queuing this in a tree you maintain?
> 
> I don't maintain the firmware tree, therefore I cannot do that.

I see.

MAINTAINERS doesn't have any hits for the firmware/ directory. Who's is
supposed to handle patches like this one?


Paul Bolle

