Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab3DXOmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 10:42:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab3DXOmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 10:42:38 -0400
Date: Wed, 24 Apr 2013 10:42:26 -0400
From: Don Zickus <dzickus@redhat.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-watchdog@vger.kernel.org, kexec@lists.infradead.org,
        wim@iguana.be, LKML <linux-kernel@vger.kernel.org>, vgoyal@redhat.com,
        dyoung@redhat.com
Subject: Re: [PATCH v3] watchdog: Add hook for kicking in kdump path
Message-ID: <20130424144226.GI79013@redhat.com>
References: <1366233596-34681-1-git-send-email-dzickus@redhat.com>
 <87li8gaku0.fsf@xmission.com>
 <20130418130009.GH79013@redhat.com>
 <20130418134904.GC2767@roeck-us.net>
 <20130418135257.GL79013@redhat.com>
 <20130418145413.GA1980@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418145413.GA1980@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 07:54:13AM -0700, Guenter Roeck wrote:
> > No, that will probably work.  It is my misunderstanding.  Is there a
> > common way to check the timeout length and the ping frequency?
> > 
> Usually it is configured in /etc/watchdog.conf if the watchdog package
> is installed. The standard ping interval is "interval", the timeout is
> "watchdog-timeout". See "man watchdog.conf" for details.
> 
> Minimum and maximum values for a given watchdog driver are not exported
> to user space, so you would have to look into the driver sources to find
> out what they are.

Hi Guenter,

Is there an easy way to determine which driver is loaded for each
/dev/watchdogN device (from a script perspective).

Basically, I wanted to determine the module that needs to be included in
the kdump initrd image.

Thanks,
Don
