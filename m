Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaFKInN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:43:13 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:59455 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaFKInK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:43:10 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: ARC: CONFIG_ARC_MMU_V4
Thread-Topic: ARC: CONFIG_ARC_MMU_V4
Thread-Index: AQHPhU7Maismt16vX0ugfypGeae+Ag==
Date: Wed, 11 Jun 2014 08:43:03 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230751A6B701C@IN01WEMBXA.internal.synopsys.com>
References: <1402475161.3798.49.camel@x220>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.93]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 June 2014 01:56 PM, Paul Bolle wrote:
> Hi Vineet,
>
> Commit ef680cdc2437 ("ARC: Disable caches in early boot if so
> configured") landed in linux-next yesterday (ie, next-20140610). It
> includes two optional tests for CONFIG_ARC_MMU_V4. There's no Kconfig
> symbol ARC_MMU_V4 in linux-next.
>
> I assume you've got that symbol queued somewhere. Is that correct?

My bad - MMU_V4 support is still in works, and not ready for mainline yet. If you
wish you could submit a patch to nuke it.

Thx,
-Vineet
