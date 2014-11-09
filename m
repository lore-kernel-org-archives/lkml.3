Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaKIXGa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 18:06:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbaKIXG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 18:06:28 -0500
Message-ID: <545FF36B.6060801@suse.de>
Date: Mon, 10 Nov 2014 00:06:19 +0100
From: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>
CC: Guenter Roeck <linux@roeck-us.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v5 33/48] staging: nvec: Register with kernel power-off
 handler
References: <1415292213-28652-1-git-send-email-linux@roeck-us.net> <1415292213-28652-34-git-send-email-linux@roeck-us.net> <5008744.rVN94atT9b@ax5200p>
In-Reply-To: <5008744.rVN94atT9b@ax5200p>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.11.2014 um 22:41 schrieb Marc Dietrich:
> Am Donnerstag 06 November 2014, 08:43:17 schrieb Guenter Roeck:
>> Register with kernel power-off handler instead of setting pm_power_off
>> directly. Register with default priority since we don't know any better.
>>
>> Cc: Julian Andres Klode <jak@jak-linux.org>
>> Cc: Marc Dietrich <marvin24@gmx.de>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net
> 
> ok, this version (V5) actually switches the device off in contrast to the 
> first implementation. Somehow I have to find out why it works at all without 
> irqs.
> 
> Acked-by: Marc Dietrich <mavin24@gmx.de>

'r' missing in email? :)

Cheers,
Andreas

-- 
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 21284 AG Nürnberg
