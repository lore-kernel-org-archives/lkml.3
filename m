Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbaJHToH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:44:07 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:62403 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbaJHToG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:44:06 -0400
Date: Wed, 8 Oct 2014 01:12:51 -0700
From: Serguey Parkhomovsky <xindigo@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: rtl8712: fix unnecessary elses after
 return/break in rtl8712_efuse.c
Message-ID: <20141008081251.GA27404@fedora.localdomain>
References: <20141008034245.GA26853@fedora.localdomain>
 <1412787427.3438.35.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412787427.3438.35.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> This sort of test is generally better where the
> individual tests are written on separate lines like:
> 
> 			if ((data[idx] != pktdata[i]) ||
> 			    (data[idx+1] != pktdata[i+1])) {
> 

Thanks for all the suggestions, Joe. I'll upload a revised patch soon.

Serguey
