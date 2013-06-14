Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab3FNWco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 18:32:44 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:33833 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab3FNWcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 18:32:42 -0400
MIME-Version: 1.0
In-Reply-To: <3168584.RRBYoY5UXf@vostro.rjw.lan>
References: <1417592.vuSG0cUIGo@vostro.rjw.lan>
	<1371162234.21540.43.camel@misato.fc.hp.com>
	<3908561D78D1C84285E8C5FCA982C28F2DA7C18E@ORSMSX106.amr.corp.intel.com>
	<3168584.RRBYoY5UXf@vostro.rjw.lan>
Date: Fri, 14 Jun 2013 15:32:42 -0700
Message-ID: <CA+8MBbKZBvqVA+wKTK7GpXorpBvDLGCJURc+PQz+QfDiwA1a8A@mail.gmail.com>
Subject: Re: [PATCH 0/5] ACPI / scan: Make it possible to use the container
 hotplug with other scan handlers
From: Tony Luck <tony.luck@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "Lu, Aaron" <aaron.lu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 3:23 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Can you please just test patch [5/5] alone without patches [1-4/5]?  We believe
> that this should work too and if that's the case, we'll only need that patch
> and a reworked [1/5].

Your belief is sound - I popped all five patches and then applied just
5/5 ... and
the system still works.

-Tony
