Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab3DMXOb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 19:14:31 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:36309 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab3DMXO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 19:14:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130413152602.GO6858@8bytes.org>
References: <1365538384-12426-1-git-send-email-joro@8bytes.org>
	<CAKocOOP5tMsDLS8Wotu0kMNjSVJpN+pPhE9zj+n9ZKS9EcVR+A@mail.gmail.com>
	<20130412080637.GN6858@8bytes.org>
	<CAJtEV7aLa2tKw-B0f0ZNHdP86yxpvUAofs9eVPYCeib6m67f8g@mail.gmail.com>
	<20130413152602.GO6858@8bytes.org>
Date: Sat, 13 Apr 2013 17:14:24 -0600
Message-ID: <CAKocOOMZ-s-SHdJ0mb=EngiS2szGraK+=GNPpkmwALhi1hutnQ@mail.gmail.com>
Subject: Re: [PATCH 0/9] AMD IOMMU cleanups, fixes and IVRS bug workarounds
From: Shuah Khan <shuahkhan@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Andrew Cooks <acooks@gmail.com>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 13, 2013 at 9:26 AM, Joerg Roedel <joro@8bytes.org> wrote:
> On Sat, Apr 13, 2013 at 11:06:22PM +0800, Andrew Cooks wrote:
>> On Fri, Apr 12, 2013 at 4:06 PM, Joerg Roedel <joro@8bytes.org> wrote:
>
>> > Oh, that's sad. You were the only one having a machine wich actually has
>> > unity-mapped ranges defined in the BIOS table. The code for those
>> > mappings was basically untested before you ran it on that machine.
>> >
>> What is the machine in question? Maybe someone else has access to one,
>> if it's not too exotic.
>
> Shuah had access to a HP server machine (don't know which one) that
> defined unity-map ranges in the BIOS table. Shuah certainly knows the
> details about that machine.
>

Joerg/Andrew,

It is a DL385 Gen8 server. Unfortunately I left HP as of yesterday and no longer
have access to the system. Maybe there others that have access to one.

-- Shuah
