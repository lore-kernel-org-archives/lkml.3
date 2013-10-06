Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab3JFUeA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 16:34:00 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55401 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab3JFUd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 16:33:58 -0400
Date: Sun, 6 Oct 2013 21:33:53 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] acpi: update win8 OSI blacklist
Message-ID: <20131006203353.GA19795@srcf.ucam.org>
References: <1380820383-23336-1-git-send-email-felipe.contreras@gmail.com>
 <20131004161226.GA22784@srcf.ucam.org>
 <CAMP44s0tqKBgUTzFnbTMqDVVWLcaDC5VKd9mq_w+T_Yu19KXqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s0tqKBgUTzFnbTMqDVVWLcaDC5VKd9mq_w+T_Yu19KXqQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 03:29:10PM -0500, Felipe Contreras wrote:
> On Fri, Oct 4, 2013 at 11:12 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > On Thu, Oct 03, 2013 at 12:13:03PM -0500, Felipe Contreras wrote:
> >> More people have reported they need this for their machines to work
> >> correctly.
> >
> > Can you add a comment to each indicating why they're being added so we
> > can easily remove them again once the problem is fixed?
> 
> Because that's what users report:
> https://bugzilla.kernel.org/show_bug.cgi?id=60682

Yes. For each entry, add a comment describing the specific bug seen.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
