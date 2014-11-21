Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbaKUOhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 09:37:34 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54860 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751368AbaKUOhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 09:37:33 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Xue, Ken" <Ken.Xue@amd.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
        "mika.wasterberg@linux.intel.com" <mika.wasterberg@linux.intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Jeff" <Jeff.Wu@amd.com>
Subject: Re: [PATCH] acpi:apd:add AMD ACPI2Platform device support for x86 system.
Date: Fri, 21 Nov 2014 15:58:41 +0100
Message-ID: <4186825.AlJiqLqNxs@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <4AC89B18A26BAB43B540DB1C94E2802C05A47EDE@scybexdag03.amd.com>
References: <1416290291-5802-1-git-send-email-Ken.Xue@amd.com> <4AC89B18A26BAB43B540DB1C94E2802C05A47EDE@scybexdag03.amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 21, 2014 05:15:46 AM Xue, Ken wrote:
> Hi Len,  Rafael J & Mika,
> 	Please help to review this patch. And tell me any of your concern. Thanks.
> 
> 	I understand it is a trend that convert a ACPI device to be a platform device.
> 	For AMD, we try to use this patch to match this trend well. The patch based on INTEL LPSS . 
> 	But we cannot reuse LPSS, because of specific definition of "lpss_device_desc" for LPSS.


You don't have to resend the patch every day for us to notice it.  We're
actually in the process of reviewing your original submission.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
