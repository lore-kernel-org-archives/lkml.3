Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab3GKBat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 21:30:49 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:39035 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab3GKBar convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 21:30:47 -0400
X-AuditID: cbfec37d-b7f036d000004805-79-51de0ac58203
From: Shuah Khan <shuah.kh@samsung.com>
To: =?iso-8859-1?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>
Cc: "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "key@linux.vnet.ibm.com" <key@linux.vnet.ibm.com>,
        "mail@srajiv.net" <mail@srajiv.net>,
        "tpmdd@selhorst.net" <tpmdd@selhorst.net>,
        "tpmdd@sirrix.com" <tpmdd@sirrix.com>,
        "matthew.garrett@nebula.com" <matthew.garrett@nebula.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [tpmdd-devel] [PATCH 3/4] tpm: Convert tpm_tis driver to use
 dev_pm_ops from legacy pm_ops
Thread-topic: [tpmdd-devel] [PATCH 3/4] tpm: Convert tpm_tis driver to use
 dev_pm_ops from legacy pm_ops
Thread-index: AQHOfSNvkGU/clZYN0+5ktv00oxarA==
Date: Thu, 11 Jul 2013 01:30:43 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61738C1B@sisaex02sj>
References: <1373429409-3944-1-git-send-email-shuah.kh@samsung.com>
 <201307110051.04726.PeterHuewe@gmx.de>
 <B8EFE96D1287C24090BAD9D858E15E61738933@sisaex02sj>
 <201307110137.32309.PeterHuewe@gmx.de>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9hP92jXPcCDaa+ULdYcvEqu8WSpgyL
	WRtvsFtc3jWHzeLDooVsFh8/2Vi83feT3WL1nhfMFo9XvGW36F/Yy2Sxv7OD0eLrTweLlt9v
	mCw2999ktfj//g+LA7/Hzll32T0+fIzzWLCp1GPPxJNsHov3vGTyeHBoM4vH7gWfmTwWXmlm
	8nh8Mdmj6eAZdo9Hi1sYPe4dOcjkMX3eTyaPz5vkAviiuGxSUnMyy1KL9O0SuDLW/epkLHgk
	UNGxbxlzA+N+3i5GTg4JAROJ07c3M0HYYhIX7q1n62Lk4hASWMYoMWHtBFYIp5dJ4unEA1DO
	fEaJX0dusIC0sAmoS3x+vYO9i5GDQ0TAVOJGvx1IDbPAbDaJFzfeMYPUCAtkSsz8/h6qJkvi
	QHsNSFhEQE9izb1nYJtZBFQlbs2cyg5i8wrYS2za9xTMFhI4zSix6EkpiM0IdN33U2vA6pkF
	xCWaW2+yQFwtILFkz3lmCFtU4uXjf6wgqyQEFCW2r7aCKNeR6P3+jRnC1pZ48u4CK8QqQYkf
	k++xTGAUm4Vk6iwkLbOQtMxC0rKAkWUVo1hpcXJBcVJ6aoWJXnFibnFpXrpecn7uJkZIsqjd
	wXj/q80hRgEORiUeXo3Yu4FCrIllxZW5hxglOJiVRHhPTgEK8aYkVlalFuXHF5XmpBYfYmTi
	4JRqYAxzPjiHa/OGrQl5Sb8zok7lV6hq3tnkdvQC/4p1IQ3nWmftUp9eUqrm8EIx+p3YgQKO
	idLeD6wajmu+lq9NcJfqPzTh5fq9TPVb5p4sTi7nMzzktfHKnxWNW7Y0+fGESS5f1b75f3iA
	36P6QrM739sfVCw1sgt4Gqz+m1UpUIB3wfFL7nqhF5RYijMSDbWYi4oTAX8RCar0AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 07/10/2013 05:30 PM, Peter Hüwe wrote:

>>
>> tpm_tis_resume() is defined originally in CONFIG_PM_SLEEP scope. I can
>> make the change to have tpm_tis_resume() not be in CONFIG_PM_SLEEP scope
>> and remove this CONFIG_PM_SLEEP when defining .pm.
>> That does make sense looking at tpm_pm_suspend() and tpm_pm_resume() which
>> are defined ithout CONFIG_PM_SLEEP scope. Sounds like the right approach?
>> I will redo the patch and send v2.
>
> Hmm,
> at first I thought that would be a good idea, however scrolling to the git
> history I found:
>
> commit 07368d32f1a67e797def08cf2ee3ea1647b204b6
> Author: Rafael J. Wysocki <rjw@sisk.pl>
> Date:   Thu Aug 9 23:00:35 2012 +0200
>
>      tpm_tis / PM: Fix unused function warning for CONFIG_PM_SLEEP
>
>      According to a compiler warning, the tpm_tis_resume() function is not
>      used for CONFIG_PM_SLEEP unset, so add a #ifdef to prevent it from
>      being built in that case.
>
>      Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>
> So removing it there would effectively revert the patch and re-enable the
> warning.
>
>
>
>> I find that the use of CONFIG_PM, CONFIG_PM_SLEEP, and CONFIG_PM_RUNTIME
>> are not very consistent. :)
> Yes.
>
> Maybe the better idea is to add the correct CONFIG_PM ifdefs for all code
> paths related to PM.
> Or leave the CONFIG_PM for tpm_tis_resume as it is.
>
>

For now, leaving tpm_tis_resume() is better to keep this change simpler. 
I am seeing this type of inconsistency in several drivers as I am going 
around making changes to convert from legacy pm_ops to dev_pm_ops. At 
some point, it might be worth while looking at the usage of these 
defines and set some clear guidelines.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
