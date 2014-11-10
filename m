Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaKJU7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:59:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33878 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbaKJU7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:59:19 -0500
Message-ID: <546126FF.3070600@zytor.com>
Date: Mon, 10 Nov 2014 12:58:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
CC: =?windows-1252?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Matt Fleming <matt.fleming@intel.com>, Borislav Petkov <bp@alien8.de>,
        Mark Salter <msalter@redhat.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH] rtc: Disable EFI rtc for x86
References: <1412339576-17972-1-git-send-email-matt@console-pimps.org> <20141109182231.GA29337@pd.tnic> <1415618533.14686.239.camel@mfleming-mobl1.ger.corp.intel.com> <201411101723.49197@pali> <5460EB92.1090501@gmail.com> <20141110170417.GA17286@srcf.ucam.org> <5461220E.20605@gmail.com>
In-Reply-To: <5461220E.20605@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2014 12:37 PM, Austin S Hemmelgarn wrote:
> On 2014-11-10 12:04, Matthew Garrett wrote:
>> On Mon, Nov 10, 2014 at 11:45:06AM -0500, Austin S Hemmelgarn wrote:
>>
>>> I agree, without it you need PC CMOS RTC support to access the RTC
>>> on most systems, which in turn means that you have to enable the CSM
>>> in the EFI firmware, which is annoying cause you can't easily dual
>>> boot windows with secure boot when the CSM is enabled.
>>
>> CMOS RTC support doesn't depend on the CSM.
>>
> That's really interesting, because with it compiled in, I can't boot on
> my EFI based thinkpad laptop without telling EFI to launch the CSM, and
> with it compiled out, I can boot fine without the CSM.  I'll have to
> look further into the options I have set in my kernel build, I may have
> changed something else without remembering between booting with and
> without the CSM enabled.
> 

It could also be that the non-CSM BIOS somehow remaps the CMOS registers.

	-hpa

