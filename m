Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbaIPQNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:13:23 -0400
Received: from p3plex2out02.prod.phx3.secureserver.net ([184.168.131.14]:53444
	"EHLO p3plex2out02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754314AbaIPQNW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:13:22 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 00/11] staging: comedi: move comedi_fc functionality
 into core
Thread-Topic: [PATCH 00/11] staging: comedi: move comedi_fc functionality
 into core
Thread-Index: AQHP0OMNmwbEu0+4Q0ufFBkx+BURX5wCgL7ggAFW6gCAABffQA==
Date: Tue, 16 Sep 2014 16:13:20 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825FA452D@P3PWEX4MB008.ex4.secureserver.net>
References: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
 <DC148C5AA1CEBA4E87973D432B1C2D8825FA1BE3@P3PWEX4MB008.ex4.secureserver.net>
 <5417EA5C.3090405@mev.co.uk>
In-Reply-To: <5417EA5C.3090405@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 16, 2014 12:44 AM, Ian Abbott wrote:
> On 15/09/14 19:21, Hartley Sweeten wrote:
>> Other than I think the comedi_fc.c functions should be migrated to
>> comedi_buf.c instead of drivers.c I have not problems with this.
>
> I think it's debatable. The only one of the three functions you 
> mentioned that touches the buffer is comedi_inc_scan_progress(), and I'd 
> rather keep that with comedi_bytes_per_scan().

Fair enough. I might end up moving some of them later based on some patches
I'm working on, but for now having them in drivers.c is fine.

>> And, patch 11 does have a conflict with your "... use dma_alloc_coherent..."
>> patches.
>
> Yes, I'll have to fix up one or the other, depending which gets applied 
> first (unless git can magically sort it out with a three way merge).

If not it's an easy rebase.

Regards,
Hartley

