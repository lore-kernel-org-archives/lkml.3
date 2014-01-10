Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbaAJBFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 20:05:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbaAJBFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 20:05:22 -0500
Message-ID: <52CF4731.6090106@redhat.com>
Date: Thu, 09 Jan 2014 20:04:49 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Dave Young <dyoung@redhat.com>,
        Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH] acpi memory hotplug, add parameter to disable memory
 hotplug for kexec
References: <1389220181-14474-1-git-send-email-prarit@redhat.com> <3476878.EqQiEtA2Ag@vostro.rjw.lan> <20140109150053.GD25897@redhat.com> <CAHGf_=oaPZNE8tVsZ1C1z3mHee8MK6CkuZ0YBTcJpRrTWgVn6g@mail.gmail.com> <20140109214425.GD12111@redhat.com>
In-Reply-To: <20140109214425.GD12111@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/09/2014 04:44 PM, Vivek Goyal wrote:
> On Thu, Jan 09, 2014 at 04:34:16PM -0500, KOSAKI Motohiro wrote:
>> On Thu, Jan 9, 2014 at 10:00 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>> On Thu, Jan 09, 2014 at 12:00:29AM +0100, Rafael J. Wysocki wrote:

> 
> Makes sense. Something like "acpi_no_memhotplug" or "acpi_disable_memhotplug"
> or something else.
> 

FWIW ... after thinking about it and some of the other debug I've had to do,
maybe acpi=no_memhotplug and acpi=no_cpuhotplug are in order here.  I've had to
disable both during hardware enablement debug and it seems that it "fits" the
current acpi disabling scheme.

Unless, of course, Rafael still objects.

P.
