Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab3GXHOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 03:14:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58091 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3GXHOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 03:14:31 -0400
Message-ID: <1374650063.7333.51.camel@marge.simpson.net>
Subject: Re: Linux 3.11-rc2 (acpi backlight)
From: Mike Galbraith <bitbucket@online.de>
To: James Hogan <james@albanarts.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Kamal Mostafa <kamal@canonical.com>,
        Steven Newbury <steve@snewbury.org.uk>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Date: Wed, 24 Jul 2013 09:14:23 +0200
In-Reply-To: <CAAG0J98G64DGvtA3HtY7B2-rvOordrzam+jjy=kjgLTW0WPgew@mail.gmail.com>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
	 <9012759.Alzqtdvh5b@vostro.rjw.lan> <1374605189.31029.25.camel@fourier>
	 <1657635.t6GA9ja9Ss@vostro.rjw.lan>
	 <CAAG0J98G64DGvtA3HtY7B2-rvOordrzam+jjy=kjgLTW0WPgew@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:S0+a+LmgTEu1c7MluhYxr+r+Bsx/Xd45rpeyM1KtxRB
 BSDysec7+xEHijY2WiyG4cOx0p8X8xZgBRDTywIU62Jnjv3M+9
 g/SFJkNM6fPeMcs5GxUrWhMEGqhhnaNCdO7/AqVG+dckbKR9ky
 ld4Gyk8DZN4LfUtuRV5R/NgwD//KckNqQIcsDzqfBCyuHInCwb
 CclxkfLYDzJ+GbMlLgr84OEX/+VNbAGqlCOUcpc+U4o+h8q3fG
 cHaalSLqh66whN91iV6Z/aNSVWso4s7nMtnK8k+kWhuwTEWdfl
 kURd7+M9bAmWlmukMY5nYdLZZTZpPQGcq2iVM8GHsIAvZUcDJh
 7oBlWlzW5ZibToPAU4kZSFSBpXTa+gOhJ8Yxwha3gkz2h3LwOU
 kv6PKlik0myeg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-24 at 07:49 +0100, James Hogan wrote: 
> On 24 July 2013 01:05, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > I'd like to collect some information on the systems having problems with those
> > two commits (to see if they are similar somehow).
> >
> > It seems that one common symptom is that brightness cannot be controlled
> > through function keys.  Is that correct for all of you?  If so, did you try
> > any other way to control brightness, like a GUI-based?
> 
> For me both the Fn keys and the gui slider (kde) now control
> /sys/class/backlight/intel_backlight/brightness (which has no effect).
> Previously they both controlled the acpi one (that on -rc2 doesn't
> exist).

Hm, poking Fn keys make kde slider widget appear on my Toshiba Satellite
but do nada, never did, and I never looked into it, assumed there was no
canned functionality for my lappy, so use a setpci script instead.

Lappy has acpi_video0, which gui is twiddling, and does nothing, as does
toshiba, while intel_backlight works.

Suppose I should put latest/greatest kernel on the thing, maybe my Fn
keys will magically start turning the _right_ knob.

-Mike

