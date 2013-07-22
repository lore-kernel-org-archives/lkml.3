Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266Ab3GVToY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 15:44:24 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:33170 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932820Ab3GVToX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 15:44:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Hogan <james@albanarts.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kamal Mostafa <kamal@canonical.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Steven Newbury <steve@snewbury.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: Linux 3.11-rc2
Date: Mon, 22 Jul 2013 21:54:21 +0200
Message-ID: <9012759.Alzqtdvh5b@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CA+55aFyrMRDD8qe9DYXixaSLJXEURMYYku1azABA72m71_X+cA@mail.gmail.com>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com> <5728692.GlhGgHY92H@vostro.rjw.lan> <CA+55aFyrMRDD8qe9DYXixaSLJXEURMYYku1azABA72m71_X+cA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 22, 2013 11:11:54 AM Linus Torvalds wrote:
> On Mon, Jul 22, 2013 at 6:02 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > Linus, do you want me to send a pull request reverting 8c5bd7a and efaa14c?
> 
> Yes, but let's wait a while. Not because I think we'll fix the problem
> (hey, miracles might happen), but because I think it would be useful
> to couple the reverts with information about the particular machines
> that broke (and the people who reported it). So that when we
> inevitably try again, we can perhaps get some testing effort with
> those machines/people.
> 
> It doesn't seem to be a show-stopped for a large number of people, so
> there's no huge hurry. I'd suggest doing the revert just in time for
> rc3, but waiting until then to gather info about people who see
> breakage.
> 
> Sound like a plan?

Yes, it does.

Rafael

