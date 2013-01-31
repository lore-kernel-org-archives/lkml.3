Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab3AaWmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:42:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41895 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab3AaWmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:42:18 -0500
Date: Thu, 31 Jan 2013 14:42:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: rtc-linux@googlegroups.com
Cc: "devendra.aaru" <devendra.aaru@gmail.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] Re: [patch v1 4/5] rtc: da9055 change irq state to
 default
Message-Id: <20130131144217.f9b1b265.akpm@linux-foundation.org>
In-Reply-To: <CAHdPZaPqAHcM8BsApRUm8mqtum67RSUA+gDWgjuhwc6VXNozwA@mail.gmail.com>
References: <1358486792.14373.14.camel@dhruva>
	<CAHdPZaPqAHcM8BsApRUm8mqtum67RSUA+gDWgjuhwc6VXNozwA@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2013 01:10:40 -0500
"devendra.aaru" <devendra.aaru@gmail.com> wrote:

> On Fri, Jan 18, 2013 at 12:26 AM, Ashish Jangam
> <ashish.jangam@kpitcummins.com> wrote:
> > This patch changes the irq state from high to the now default low
> > state.
> >
> 
> will you please provide more info on why do we need to set it to low state?

Yes, I would also like more details about this patch, please.
