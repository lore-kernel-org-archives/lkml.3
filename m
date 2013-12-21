Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab3LUD5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 22:57:30 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:58752 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab3LUD52 (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Fri, 20 Dec 2013 22:57:28 -0500
Subject: Re: [RFC PATCH 07/14] rtc-efi: add GMTOFF support to rtc_efi
From: joeyli <jlee@suse.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "samer.el-haj-mahmoud@hp.com" <samer.el-haj-mahmoud@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "Elliott@hp.com" <Elliott@hp.com>, "werner@suse.com" <werner@suse.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "oneukum@suse.de" <oneukum@suse.de>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "trenn@suse.de" <trenn@suse.de>,
        "JBeulich@suse.com" <JBeulich@suse.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "matt@console-pimps.org" <matt@console-pimps.org>
In-Reply-To: <1387552304.17961.0.camel@x230>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
	 <1387439515-8926-8-git-send-email-jlee@suse.com>
	 <1387552304.17961.0.camel@x230>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Dec 2013 11:56:01 +0800
Message-ID: <1387598161.3539.5058.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 五，2013-12-20 於 15:11 +0000，Matthew Garrett 提到：
> On Thu, 2013-12-19 at 15:51 +0800, Lee, Chun-Yi wrote:
> > This patch adds 2 new iotrl: RTC_RD_GMTOFF and RTC_SET_GMTOFF to
> > rtc_efi support get/set gmt offset that mapping to the GUN's tm_gmtoff
> > extension (Seconds east of UTC).
> 
> Shouldn't this information also be exported via the rtc-sysfs interface?
> 

Thanks for your suggestion, I will also export it to rtc-sysfs.

Joey Lee

