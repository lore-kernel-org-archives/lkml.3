Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034Ab3BMQiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:38:10 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:35389 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759377Ab3BMQiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:38:08 -0500
Message-ID: <511BC16C.7040807@gmail.com>
Date: Wed, 13 Feb 2013 08:38:04 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 0/5] Add P state driver for Intel Core Processors
References: <1360170133-5066-1-git-send-email-dirk.brandewie@gmail.com> <20130212214949.GA1003@redhat.com>
In-Reply-To: <20130212214949.GA1003@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On 02/12/2013 01:49 PM, Dave Jones wrote:
> On Wed, Feb 06, 2013 at 09:02:07AM -0800, dirk.brandewie@gmail.com wrote:
>
> Won't you also need to patch drivers/cpufreq/acpi-cpufreq.c to not load
> on the processors that you want this driver to run on ?
>
> 	Dave
>

For the case where both are built-in the load order works my driver uses
device_initcall() and acpi_cpufreq uses late_initcall().

For the case where both are a module (which I was sure I tested) you are right
I will have to do something.

For now I propose to make my driver built-in only while I sort out the right
solution for the module build.  Does this seem reasonable to everyone?

--Dirk

