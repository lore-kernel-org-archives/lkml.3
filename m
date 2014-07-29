Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbaG2Jxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:53:48 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:49679 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbaG2Jxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:53:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAHTgTXXB2rfYyLwBM9BF7pw6kTVnixXhKWweKKZtsH64drAhQw@mail.gmail.com>
References: <5386F2C7.8080400@redhat.com> <1524296.Cxrf5UDWlv@vostro.rjw.lan>
 <CAHTgTXXUcDNvPD0g82q1HFCy+EZZdF8hwyAzRu8cijs5dy9mBQ@mail.gmail.com>
 <CAHTgTXV8RtMwO0bKrc7LmfVcAQzkBra=RWQ6AGo7H8NsaxQx9A@mail.gmail.com> <CAHTgTXXB2rfYyLwBM9BF7pw6kTVnixXhKWweKKZtsH64drAhQw@mail.gmail.com>
From: William Dauchy <wdauchy@gmail.com>
Date: Tue, 29 Jul 2014 11:53:26 +0200
Message-ID: <CAJ75kXYJL4jD=81NYPYpji9grJQkzMKdgLhRMA=YFstHzzZ0=A@mail.gmail.com>
Subject: Re: WARNING: CPU: 0 PID: 2623 at drivers/pnp/pnpacpi/core.c:96 pnpacpi_set_resource
To: Vinson Lee <vlee@twopensource.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Zdenek Kabelac <zkabelac@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinson,

On Mon, Jul 28, 2014 at 9:11 PM, Vinson Lee <vlee@twopensource.com> wrote:
> The warning first happens with 3.14-rc1. The warning does not occur with 3.13.0.

Hitting the same issue here with a similar trace on 3.14.x. Did you
start bisecting?

Regards,
-- 
William
