Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455Ab3ENUjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 16:39:08 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3792 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757884Ab3ENUjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 16:39:07 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <5192A0DE.90209@broadcom.com>
Date: Tue, 14 May 2013 22:38:54 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329
 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>
Subject: Re: REGRESSION: 3.10-rc1: Dell Latitude e6410 hangs within 3
 seconds
References: <5192363E.7040204@broadcom.com>
 <1396357.SFbZsj3Bmy@vostro.rjw.lan>
In-Reply-To: <1396357.SFbZsj3Bmy@vostro.rjw.lan>
X-WSS-ID: 7D8C7F8131W19351901-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 10:34 PM, Rafael J. Wysocki wrote:
> On Tuesday, May 14, 2013 03:03:58 PM Arend van Spriel wrote:
>> Laptop hangs pretty soon after booting. Workaround for me was to turn
>> off ACPI on kernel command line, ie. acpi=off
>>
>> Attached is my kernel configuration.
>
> Well, I have no idea what may be the source of this.

Me neither.

> Any chance to bisect?

can try. Rebuilding kernels can be a drag :-p

Regards,
Arend


