Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab3EMUDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 16:03:08 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:55897 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755154Ab3EMUDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 16:03:07 -0400
Message-ID: <1368475385.1350.70.camel@x61.thuisdomein>
Subject: Re: [PATCH] myri_sbus: remove firmware
From: Paul Bolle <pebolle@tiscali.nl>
To: David Miller <davem@davemloft.net>
Cc: mason@myri.com, linux-kernel@vger.kernel.org
Date: Mon, 13 May 2013 22:03:05 +0200
In-Reply-To: <20130405.125530.727706283199340601.davem@davemloft.net>
References: <1365171782.1830.67.camel@x61.thuisdomein>
	 <20130405.125530.727706283199340601.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 May 2013 20:03:05.0779 (UTC) FILETIME=[E1C6C030:01CE5014]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

On Fri, 2013-04-05 at 12:55 -0400, David Miller wrote:
> From: Paul Bolle <pebolle@tiscali.nl>
> > Support for MyriCOM Gigabit Ethernet cards was removed in v3.1. Remove
> > the firmware too.
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

I don't think this patch has been queued for mainline anywhere. Would
you mind queuing this in a tree you maintain?


Paul Bolle

