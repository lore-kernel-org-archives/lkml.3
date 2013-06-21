Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272Ab3FUBaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 21:30:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758018Ab3FUBav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 21:30:51 -0400
Date: Fri, 21 Jun 2013 02:30:45 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Geremy Condra <gcondra@google.com>
Cc: dm-devel@redhat.com, wad@chromium.org, linux-kernel@vger.kernel.org,
        agk@redhat.com
Subject: Re: [dm-devel] [PATCH] dm: verity: Add support for emitting
	uevents on dm-verity errors.
Message-ID: <20130621013045.GJ23042@agk-dp.fab.redhat.com>
Mail-Followup-To: Geremy Condra <gcondra@google.com>, dm-devel@redhat.com,
	wad@chromium.org, linux-kernel@vger.kernel.org, agk@redhat.com
References: <1371763260-9933-1-git-send-email-gcondra@google.com> <20130621005905.GI23042@agk-dp.fab.redhat.com> <CAEQjtanyk2mw2LHMruU+4ujj4KsTtgyfh=3ABk+3g77Bn-6W3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEQjtanyk2mw2LHMruU+4ujj4KsTtgyfh=3ABk+3g77Bn-6W3g@mail.gmail.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 06:12:07PM -0700, Geremy Condra wrote:
> Assuming nobody currently using DM_UEVENT minds it doesn't cause any
> problems for me. Any current users object?
 
DM_UEVENT toggles uevents on or off across the whole of device-mapper.

If there is no particular need for verity *not* to generate uevents
while other parts of device-mapper *are* generating them, then we can
make do with just the one Kconfig parameter.  (Userspace is still free
to ignore particular events.)

So let's drop the second config parameter.

Alasdair

