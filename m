Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254Ab3GVTqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 15:46:14 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:33177 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932820Ab3GVTqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 15:46:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <matthew.garrett@nebula.com>,
        Steven Newbury <steve@snewbury.org.uk>
Cc: James Hogan <james@albanarts.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kamal Mostafa <kamal@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: Linux 3.11-rc2
Date: Mon, 22 Jul 2013 21:56:15 +0200
Message-ID: <1943327.gJaLv781Zb@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1374516979.2641.0.camel@x230>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com> <5728692.GlhGgHY92H@vostro.rjw.lan> <1374516979.2641.0.camel@x230>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 22, 2013 06:16:20 PM Matthew Garrett wrote:
> On Mon, 2013-07-22 at 15:02 +0200, Rafael J. Wysocki wrote:
> 
> > In the meantime I received a report from Steven Newbury that these changes
> > broke things for him too, so we need to revert commits 8c5bd7a and efaa14c.
> > The other two commits in the series should be benign.
> 
> Could you let me know the details of this problem?

Steven, can you please describe the problem you're seeing to Matthew and
the other people on the list?

Rafael

