Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbaAIEBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 23:01:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50707 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbaAIEBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 23:01:41 -0500
Message-ID: <52CE1EF6.40300@zytor.com>
Date: Wed, 08 Jan 2014 20:00:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: joeyli <jlee@suse.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org
Subject: Re: [RFC PATCH 04/14] ACPI: Add ACPI 5.0 Time and Alarm Device driver
References: <1387439515-8926-1-git-send-email-jlee@suse.com>	 <1387439515-8926-5-git-send-email-jlee@suse.com>	 <52B30F43.1060306@zytor.com> <1387518099.3539.4453.camel@linux-s257.site>	 <52C3647B.7000708@zytor.com> <1388998707.3539.6070.camel@linux-s257.site>	 <52CB929C.6050403@zytor.com> <1389091244.3539.6095.camel@linux-s257.site>	 <52CC2CDF.3000100@zytor.com> <1389193142.3539.6123.camel@linux-s257.site>	 <52CD9139.2070302@zytor.com> <1389239259.24105.2.camel@linux-s257.site>
In-Reply-To: <1389239259.24105.2.camel@linux-s257.site>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 07:47 PM, joeyli wrote:
> 
> Unfortunately current acpica leaks the SystemCMOS handler:
> 
> ACPI Error: Region SystemCMOS (ID=5) has no handler (20131115/exfldio-299)
> 

I'm sorry, I can't parse either your statement or the error message...
sounds like there is a bug here, too.

	-hpa


