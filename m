Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbaA1QG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 11:06:28 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:12914 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754970AbaA1QG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 11:06:27 -0500
Date: Tue, 28 Jan 2014 11:06:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Dongsheng Yang <dongsheng081251@gmail.com>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, raistlin@linux.it, juri.lelli@gmail.com,
        clark.williams@gmail.com, mingo@redhat.com
Subject: Re: [PATCH 0/3] sched: Collect the bits about priority into a new
 header file, include/linux/sched/prio.h.
Message-ID: <20140128110623.3dba0eca@gandalf.local.home>
In-Reply-To: <CA+qeAOqW58894hGvCP0N0E-EUESfFPeqMmXUuhqxEZrRjDV97A@mail.gmail.com>
References: <20140123065204.4e0b6902@gandalf.local.home>
	<cover.1390859827.git.yangds.fnst@cn.fujitsu.com>
	<20140127104532.6a0926e9@gandalf.local.home>
	<CA+qeAOqW58894hGvCP0N0E-EUESfFPeqMmXUuhqxEZrRjDV97A@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jan 2014 23:59:06 +0800
Dongsheng Yang <dongsheng081251@gmail.com> wrote:

> Hi Steve,
> 
> Sorry for the late reply, I have been vacation for Chinese Spring Festival.
> 
> Aha, yes, it looks strange a mail from future.
> 
> Could you help to figure out which timezone is the standard one for LKML?

It should just be your own timezone. I think you had the wrong timezone
before as it was "Date: Mon, 27 Jan 2014 17:15:36 -0500". You had the
same timezone as I have (-0500). But this email is correct:

 Date: Tue, 28 Jan 2014 23:59:06 +0800

Basically, whatever you use to send email, make sure that it is set up
to send with your own timezone. There's no standard one for LKML. The
mail clients will do the conversion.

-- Steve
