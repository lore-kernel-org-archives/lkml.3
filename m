Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab3KVP5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:57:01 -0500
Received: from www17.your-server.de ([213.133.104.17]:46528 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab3KVP5A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:57:00 -0500
References: <1384980928.3312.6.camel@localhost.localdomain> <20131122105554.GK9515@nuc-i3427.alporthouse.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20131122105554.GK9515@nuc-i3427.alporthouse.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <3D7BCEE7-5788-45CE-A1B2-CB87A050A033@m3y3r.de>
Cc: airlied <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
X-Mailer: iPad Mail (11B554a)
From: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [i915] BUG: Bad page state in process Xorg
Date: Fri, 22 Nov 2013 16:56:59 +0100
To: Chris Wilson <chris@chris-wilson.co.uk>
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Am 22.11.2013 um 11:55 schrieb Chris Wilson <chris@chris-wilson.co.uk>:
> 
>> On Wed, Nov 20, 2013 at 09:55:28PM +0100, Thomas Meyer wrote:
>> Hi,
>> 
>> I reported this bug a few days ago, but nobody did respond to my bug
>> report:
>> http://lkml.indiana.edu/hypermail/linux/kernel/1311.2/00058.html
>> 
>> Every time I restart the X server I will run into this bug with 3.12.0.
> 
> I think whilst we scratch our heads wondering about what could cause
> corruption in our struct page, we would welcome a bisection. If it dies
> during X startup, it would seems like a bisection would progress
> quickly. Thanks,

No, but on every(?) shutdown of the Xorg server. So I'll try to bisect this. Hopefully I'll find some time this weekend.

> -Chris
> 
> -- 
> Chris Wilson, Intel Open Source Technology Centre
