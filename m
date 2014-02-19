Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbaBSAxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 19:53:47 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:40990 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaBSAxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 19:53:45 -0500
Message-ID: <53040096.6010100@acm.org>
Date: Tue, 18 Feb 2014 18:53:42 -0600
From: Corey Minyard <minyard@acm.org>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Matthew Garrett <matthew.garrett@nebula.com>
CC: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
References: <1392740909-2079-1-git-send-email-matthew.garrett@nebula.com> <1920764.8Poj9R8nZQ@vostro.rjw.lan> <1392765901.3488.4.camel@x230.lan> <2013495.SnSbjHoB2r@vostro.rjw.lan>
In-Reply-To: <2013495.SnSbjHoB2r@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just queued it up, too, but that's fine.  This seems to be a good idea
with the way ACPI is going.

Acked-by: Corey Minyard <cminyard@mvista.com>

On 02/18/2014 06:45 PM, Rafael J. Wysocki wrote:
> On Tuesday, February 18, 2014 11:25:02 PM Matthew Garrett wrote:
>> On Wed, 2014-02-19 at 00:35 +0100, Rafael J. Wysocki wrote:
>>> On Tuesday, February 18, 2014 11:15:08 PM Matthew Garrett wrote:
>>>> For example, if you load the ACPI power meter driver before you've
>>>> installed the ACPI IPMI driver you'll typically get failures (most
>>>> vendors implement it via IPMI).
>>> Well, any specific machine from any specific vendor?
>> The Dell R720 and HP DL385 both seem to have this configuration. I
>> believe some Ciscos do, too.
> I've queued this up for 3.15 (with the above info added to the changelog).
>
> Thanks!
>

