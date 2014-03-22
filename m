Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751016AbaCVHoL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 03:44:11 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:45961 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaCVHoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 03:44:07 -0400
Message-ID: <1395474241.6327.15.camel@marge.simpson.net>
Subject: Re: [BUG] Paravirtual time accounting / IRQ time accounting
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: lwcheng@cs.hku.hk
Cc: Glauber Costa <glommer@gmail.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 22 Mar 2014 08:44:01 +0100
In-Reply-To: <20140322144752.93371i3e3g500fgk@intranet.cs.hku.hk>
References: <20140319174222.213976eu8b54ujk0@intranet.cs.hku.hk>
	 <CAA6-i6p-=4Dk9-ujvL36EVpm80MS-BiYjw+V9JQ8g4AypBJeZw@mail.gmail.com>
	 <1395381008.6030.26.camel@marge.simpson.net>
	 <20140322144752.93371i3e3g500fgk@intranet.cs.hku.hk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-22 at 14:47 +0800, lwcheng@cs.hku.hk wrote:

> I checked the source code again. I forgot to mention that I commented out
> steal_ticks() in my experiments (sorry):

Oh well, it wasn't a _complete_ waste of time.  I now have a gaggle of
cute little alien boxen to dissect should I ever again feel inspired to
explore non silicon based CPU anatomy.

-Mike

