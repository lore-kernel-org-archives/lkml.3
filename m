Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbaAAAna (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 31 Dec 2013 19:43:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46368 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957AbaAAAn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 19:43:28 -0500
Message-ID: <52C3647B.7000708@zytor.com>
Date: Tue, 31 Dec 2013 16:42:35 -0800
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
References: <1387439515-8926-1-git-send-email-jlee@suse.com>	 <1387439515-8926-5-git-send-email-jlee@suse.com>	 <52B30F43.1060306@zytor.com> <1387518099.3539.4453.camel@linux-s257.site>
In-Reply-To: <1387518099.3539.4453.camel@linux-s257.site>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 09:41 PM, joeyli wrote:
>>
>> What platform do you have that has TAD support?  I am wondering how this
>> was tested.
>>
> 
> It's a testing platform that's only support get/set time functions of
> ACPI TAD.
> 

It would be really, really good to get this into Qemu (either SeaBIOS or
OVMF, or ideally both) so we can have anyone test.

	-hpa


