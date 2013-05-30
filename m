Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab3E3Uh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 16:37:28 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:48960 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752243Ab3E3UhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 16:37:16 -0400
Date: Thu, 30 May 2013 22:37:04 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Don Zickus <dzickus@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-watchdog@vger.kernel.org, kexec@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, vgoyal@redhat.com,
        dyoung@redhat.com
Subject: Re: [PATCH v3] watchdog: Add hook for kicking in kdump path
Message-ID: <20130530203704.GH14258@spo001.leaseweb.com>
References: <1366233596-34681-1-git-send-email-dzickus@redhat.com> <87li8gaku0.fsf@xmission.com> <20130418130009.GH79013@redhat.com> <20130418134904.GC2767@roeck-us.net> <20130418135257.GL79013@redhat.com> <20130418145413.GA1980@roeck-us.net> <20130424144226.GI79013@redhat.com> <20130424152142.GA26864@roeck-us.net> <20130527191618.GD14258@spo001.leaseweb.com> <20130528011047.GA28597@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130528011047.GA28597@roeck-us.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

> > Only when you set the .parent field in the watchdog_device data you will get the
> > referal in the /sys/class/... tree. In iTCO_wdt.c you have the following code
> > that does that: iTCO_wdt_watchdog_dev.parent = dev->dev.parent;
> > 
> > From the watchdog-kernel-api documentation:
> > * parent: set this to the parent device (or NULL) before calling
> >   watchdog_register_device.
> > 
> Hi Wim,
> 
> We live and learn ... thanks a lot for the hint!

If it's about learning: the old way was via miscdevice.parent ... I think some "old"
drivers still do this.

Kind regards,
Wim.

