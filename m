Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbbAUK0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:26:39 -0500
Received: from mail-yk0-f181.google.com ([209.85.160.181]:52179 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbbAUK03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:26:29 -0500
MIME-Version: 1.0
In-Reply-To: <20150121100901.GK1850@lahna.fi.intel.com>
References: <1418892285.17614.6.camel@kxue-X58A-UD3R>
	<1566252.Xx6LHhsTBM@vostro.rjw.lan>
	<20150121100901.GK1850@lahna.fi.intel.com>
Date: Wed, 21 Jan 2015 12:26:28 +0200
Message-ID: <CAHp75VfAAF2bTaMY32QLtsAGZGSw+D073eA4GDrjNO37=hgUfA@mail.gmail.com>
Subject: Re: [PATCH 1/3 V3] acpi:soc: merge common codes for creating platform device
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Ken Xue <Ken.Xue@amd.com>,
        linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Heikki Krogerus <heikki.krogerus@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 12:09 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Tue, Jan 20, 2015 at 04:12:16PM +0100, Rafael J. Wysocki wrote:
>> On Thursday, December 18, 2014 04:44:45 PM Ken Xue wrote:
>> >
>> > This patch is supposed to deliver some common codes for AMD APD and
>> > intel LPSS. It can help to convert some specific acpi devices to be
>> > platform devices.
>> >
>> > Signed-off-by: Ken Xue <Ken.Xue@amd.com>
>>
>> Mika, is the v3 fine with you?
>
> Yup, no objections from me.
>
> Andy, Heikki, do you have any comments?

There are style issues, mostly in the comments. I could review them,
but I really have not much time for that.



-- 
With Best Regards,
Andy Shevchenko
