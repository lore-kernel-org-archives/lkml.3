Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab3LEWVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 17:21:54 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:57899 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752825Ab3LEWVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 17:21:51 -0500
Date: Thu, 5 Dec 2013 17:21:50 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Len Brown <lenb@kernel.org>
cc: Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 0/5] PM: Enable option of re-use runtime PM callbacks at
 system suspend
In-Reply-To: <CAJvTdKnqD3ccPUzh7kNMNqrEYFfD93Vh9hgFuKyHz+pjGNHdtA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1312051720330.869-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Dec 2013, Len Brown wrote:

> This thread raises the question...
> 
> Do we still need to have PM_RUNTIME apart from PM_SLEEP?
> 
> What is the benefit of being able to build-in one one without the other?
> If that benefit is not significant, perhaps the time has come to
> replace them both with CONFIG_PM...

There are lots of embedded/SoC platforms that implement PM_RUNTIME but
not PM_SLEEP.

Alan Stern

