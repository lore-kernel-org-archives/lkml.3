Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab3ENPCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:02:19 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3400 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917Ab3ENPCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:02:18 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <519251DF.4070809@broadcom.com>
Date: Tue, 14 May 2013 08:01:51 -0700
From: "Christian Daudt" <csd@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130404
 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Paul Bolle" <pebolle@tiscali.nl>
cc: "Russell King" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: mach-bcm: drop "select GPIO_BCM"
References: <1368524085.1350.102.camel@x61.thuisdomein>
 <51924FE4.5000803@broadcom.com>
 <1368543520.1350.105.camel@x61.thuisdomein>
In-Reply-To: <1368543520.1350.105.camel@x61.thuisdomein>
X-WSS-ID: 7D8C8E9031W19200676-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-05-14 07:58 AM, Paul Bolle wrote:
> On Tue, 2013-05-14 at 07:53 -0700, Christian Daudt wrote:
>> We are planning on submitting the driver for this option for review
>> over the next couple of weeks, to get it in the 3.11 cycle. So this
>> patch won't be necessary.
> I see. Did my web searches miss something or will that be the first time
> you submit that driver for review?
Your web searches are correct. The driver was not ready for review at 
the time the initial SoC support was originally submitted, so the config 
should have been removed. It leaked out :)

  thanks,
    csd



