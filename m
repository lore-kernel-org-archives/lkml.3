Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940Ab3CYUzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 16:55:53 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:60243 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758898Ab3CYUzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 16:55:49 -0400
MIME-Version: 1.0
In-Reply-To: <D7731577-A2C0-4FC5-A7E3-62F251A18798@orcon.net.nz>
References: <1363556926-21097-1-git-send-email-will.deacon@arm.com>
 <BFB01C0A-95E5-4C2B-8AF2-A06BE1FF74E0@orcon.net.nz> <20130325133710.GD14280@mudshark.cambridge.arm.com>
 <20130325150958.GA13894@skade.schwarzvogel.de> <D7731577-A2C0-4FC5-A7E3-62F251A18798@orcon.net.nz>
From: Matt Turner <mattst88@gmail.com>
Date: Mon, 25 Mar 2013 13:55:28 -0700
Message-ID: <CAEdQ38Hx0fbFW615XhhNwv0Spg4pyeqo7BhiOTV-9CrPenPwNQ@mail.gmail.com>
Subject: Re: [PATCH] alpha: makefile: don't enforce small data model for
 kernel builds
To: Michael Cree <mcree@orcon.net.nz>
Cc: Tobias Klausmann <klausman@schwarzvogel.de>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 1:06 PM, Michael Cree <mcree@orcon.net.nz> wrote:
> On 26/03/2013, at 4:09 AM, Tobias Klausmann wrote:
>>
>> On Mon, 25 Mar 2013, Will Deacon wrote:
>>>
>>> Any news on these? I've included an updated version of the first patch,
>>> with
>>> the Tested-by-tag and a tweaked commit message below.
>>
>>
>> As a data point, I tried vanilla 3.8.4 on the weekend. With my
>> usual config on a UP1500, it will fail at build time with
>> relocation errors. If I remove -msmall-data (or replace it with
>> ~big~), the machine hangs hard immediatly after aboot telling me
>> it's starting it.
>
>
> You probably want the "alpha: Add irongate_io to to PCI bus resources" patch
> posted by Matt Turner in the linux-alpha forum.  Looks like it has not been
> sent to Linus.
>
> If Matt does not respond in the next day or two I'll collect patches and
> send them on to Linus.

Yes, please do. I haven't powered on an alpha in a few months.

Matt
