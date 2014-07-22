Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbaGVOTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:19:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:60546 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaGVOS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:18:58 -0400
Date: Tue, 22 Jul 2014 16:18:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Bruno Wolff III <bruno@wolff.to>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Scheduler regression from
 caffcdd8d27ba78730d5540396ce72ad022aff2c
Message-ID: <20140722141855.GG3935@laptop>
References: <20140718161602.GH12054@laptop.lan>
 <20140721163528.GA10433@wolff.to>
 <20140721165212.GO3935@laptop>
 <20140722094740.GJ12054@laptop.lan>
 <20140722103857.GK12054@laptop.lan>
 <20140722121001.GA30631@wolff.to>
 <20140722130343.GD3935@laptop>
 <20140722132603.GL12054@laptop.lan>
 <20140722133514.GM12054@laptop.lan>
 <20140722140912.GA23406@wolff.to>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722140912.GA23406@wolff.to>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 09:09:12AM -0500, Bruno Wolff III wrote:
> On Tue, Jul 22, 2014 at 15:35:14 +0200,
>  Peter Zijlstra <peterz@infradead.org> wrote:
> >On Tue, Jul 22, 2014 at 03:26:03PM +0200, Peter Zijlstra wrote:
> >
> >Something like so.. anything obviously broken?
> 
> Do you want me to test this change instead of, or combined with the other
> patch you wanted tested earlier?

You can put this on top of them. I hope that this will make the pr_err()
introduced in the robustify patch go away.

