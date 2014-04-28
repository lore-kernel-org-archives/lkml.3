Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbaD1PKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:10:01 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:46079 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbaD1PJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:09:54 -0400
MIME-Version: 1.0
In-Reply-To: <5358432F.8040202@gmail.com>
References: <53571685.5060403@gmail.com> <20140423032044.GA26233@kroah.com>
 <20140423115418.A8C0EC40969@trevor.secretlab.ca> <5358432F.8040202@gmail.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Mon, 28 Apr 2014 16:09:33 +0100
X-Google-Sender-Auth: N9vr0DsfeJR9JvDH00fkh2jLPxQ
Message-ID: <CACxGe6ub+10pcoOLEPhdxq=gJpA+JygW+CDFGoXmx+bO=d7KCw@mail.gmail.com>
Subject: Re: [PATCH] sysfs, device-tree: aid for debugging device tree boot problems
To: Frank Rowand <frowand.list@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 11:48 PM, Frank Rowand <frowand.list@gmail.com> wrote:
> On 4/23/2014 4:54 AM, Grant Likely wrote:
>> On Tue, 22 Apr 2014 20:20:44 -0700, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>> On Tue, Apr 22, 2014 at 06:25:25PM -0700, Frank Rowand wrote:
>>>> Create some infrastructure to aid trouble shooting device tree related
>>>> boot issues.
>>>>
>>>> Add a %driver_name file to each device tree node sysfs directory which has had
>>>> a driver bound to it.  This allows detecting device tree nodes which failed
>>>> to be bound to any driver.
>>>
>>> Why is this needed, shouldn't there already be a "driver" symlink in
>>> sysfs for these devices when a driver binds to them?  The rest of the
>>> driver model works that way, why is of devices any different?
>>>
>>
>> Because it hasn't been added yet! I only just committed the change to
>> convert device_nodes into kobjects in v3.14. The next step is to add
>> driver symlinks.
>
> No need to add a "driver" symlink.  The device directories in sysfs already
> have a driver symlink.

Sorry, I meant of_node symlink. That is the bit I've been planning to add.

g.
