Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759840Ab3BYXiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 18:38:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55950 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759584Ab3BYXiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 18:38:12 -0500
Date: Mon, 25 Feb 2013 15:38:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "'Tejun Heo'" <tj@kernel.org>
Cc: Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH] rtc: add devm_rtc_device_{register,unregister}()
Message-Id: <20130225153811.2408f9c0.akpm@linux-foundation.org>
In-Reply-To: <20130225233345.GB2679@htj.dyndns.org>
References: <000e01ce132a$be08b940$3a1a2bc0$%han@samsung.com>
	<20130225142957.8e4aca8a.akpm@linux-foundation.org>
	<20130225233345.GB2679@htj.dyndns.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2013 15:33:45 -0800
"'Tejun Heo'" <tj@kernel.org> wrote:

> On Mon, Feb 25, 2013 at 02:29:57PM -0800, Andrew Morton wrote:
> > > + * Managed rtc_device_register(). The rtc_device returned from this function
> > > + * are automatically freed on driver detach. See rtc_device_register()
> > > + * for more information.
> > > + */
> > 
> > I think the name is inappropriate.  devm functions start with "devm"
> > and rtc functions start with "rtc" and this code is a part of rtc core,
> > not a part of devm core.  Hence it should be something like
> > "rtc_devm_device_register".
> 
> I think devm_rtc_ is better.  All other devm interface functions put
> devm_ prefix first

makes no sense.  Whatever.
