Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab3LTFnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 00:43:05 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:34119 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab3LTFnE (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Fri, 20 Dec 2013 00:43:04 -0500
Subject: Re: [RFC PATCH 04/14] ACPI: Add ACPI 5.0 Time and Alarm Device
 driver
From: joeyli <jlee@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org
In-Reply-To: <52B30F43.1060306@zytor.com>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
	 <1387439515-8926-5-git-send-email-jlee@suse.com>
	 <52B30F43.1060306@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Dec 2013 13:41:39 +0800
Message-ID: <1387518099.3539.4453.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2013-12-19 於 07:22 -0800，H. Peter Anvin 提到：
> On 12/18/2013 11:51 PM, Lee, Chun-Yi wrote:
> > This patch add the driver of Time and Alarm Device in ACPI 5.0.
> > Currently it only implemented get/set time functions and grab
> > the capabilities of device when driver initial.
> > 
> > This driver also register rtc-acpitad platform device for RTC ACPITAD
> > stub driver using.
> > 
> > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> 
> What platform do you have that has TAD support?  I am wondering how this
> was tested.
> 
> 	-hpa
> 

It's a testing platform that's only support get/set time functions of
ACPI TAD.


Thanks
Joey Lee

