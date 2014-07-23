Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708AbaGWQzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:55:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:3330 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932503AbaGWQzK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:55:10 -0400
Date: Wed, 23 Jul 2014 12:55:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr =?ISO-8859-1?B?TWzhZGVr?= <pmladek@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ring-buffer: Race when writing and swapping cpu
 buffer in parallel
Message-ID: <20140723125508.5bf2972a@gandalf.local.home>
In-Reply-To: <20140723164918.GS20751@pathway.suse.cz>
References: <1405501084-16135-1-git-send-email-pmladek@suse.cz>
	<20140716124356.398e21f4@gandalf.local.home>
	<20140718153443.GC6774@pathway.suse.cz>
	<20140721144324.GG20751@pathway.suse.cz>
	<20140721154317.GS8690@linux.vnet.ibm.com>
	<20140723162845.GF23175@localhost.localdomain>
	<20140723123458.314a43fa@gandalf.local.home>
	<20140723164918.GS20751@pathway.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2014 18:49:18 +0200
Petr Mládek <pmladek@suse.cz> wrote:

> JFYI, I already have a variant based on https://lkml.org/lkml/2014/7/21/416
> It seems to work fine. I just want to double check few things before sending.

Looking forward to seeing it.

> 
> Best Regards,
> Petr
> 
> PS: I am a bit distracted now because my wife is about to give birth
> to our twins :-)

What? Doesn't the hospital have WIFI? ;-)

-- Steve
