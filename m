Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999Ab3GVSL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:11:57 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:35071 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328Ab3GVSLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:11:55 -0400
MIME-Version: 1.0
In-Reply-To: <5728692.GlhGgHY92H@vostro.rjw.lan>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
	<CAAG0J9-OgVe3Y0uo0bKr2TTcn3YUna1C_5NixBSsft3+cbKKWw@mail.gmail.com>
	<5728692.GlhGgHY92H@vostro.rjw.lan>
Date: Mon, 22 Jul 2013 11:11:54 -0700
X-Google-Sender-Auth: MChNc5w9TgXwcj6i_txua1urxAo
Message-ID: <CA+55aFyrMRDD8qe9DYXixaSLJXEURMYYku1azABA72m71_X+cA@mail.gmail.com>
Subject: Re: Linux 3.11-rc2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: James Hogan <james@albanarts.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kamal Mostafa <kamal@canonical.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Steven Newbury <steve@snewbury.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 6:02 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Linus, do you want me to send a pull request reverting 8c5bd7a and efaa14c?

Yes, but let's wait a while. Not because I think we'll fix the problem
(hey, miracles might happen), but because I think it would be useful
to couple the reverts with information about the particular machines
that broke (and the people who reported it). So that when we
inevitably try again, we can perhaps get some testing effort with
those machines/people.

It doesn't seem to be a show-stopped for a large number of people, so
there's no huge hurry. I'd suggest doing the revert just in time for
rc3, but waiting until then to gather info about people who see
breakage.

Sound like a plan?

                Linus
