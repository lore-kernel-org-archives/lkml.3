Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab3AaV3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 16:29:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44207 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523Ab3AaV3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 16:29:19 -0500
Message-ID: <510AE21D.2090002@zytor.com>
Date: Thu, 31 Jan 2013 13:29:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ian Kent <raven@themaw.net>,
        autofs@vger.kernel.org
Subject: Re: [PATCH] parisc: unbreak automounter support on 64-bit kernel
 with 32-bit userspace
References: <20130131200110.GA6032@p100.box> <1359664008.2468.5.camel@dabdike>
In-Reply-To: <1359664008.2468.5.camel@dabdike>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2013 12:26 PM, James Bottomley wrote:
> [adding autofs list and maintainer for their perusal and ack, although
> this is an obvious fix to me
> 
> James]

The #if list probably should be inverted, and only specific platforms
should have unsigned long...

	-hpa

