Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbaKISWm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 13:22:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44665 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbaKISWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 13:22:40 -0500
Date: Sun, 9 Nov 2014 19:22:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Mark Salter <msalter@redhat.com>, Matt Fleming <matt@console-pimps.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>, Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH] rtc: Disable EFI rtc for x86
Message-ID: <20141109182231.GA29337@pd.tnic>
References: <1412339576-17972-1-git-send-email-matt@console-pimps.org>
 <1412348517.5410.13.camel@deneb.redhat.com>
 <201411091837.47354@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201411091837.47354@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2014 at 06:37:46PM +0100, Pali Rohár wrote:
> this patch totally disabled efi rfc driver on x86 machines at 
> compile time. But on some x86 machines it working without crash 
> and reading from file /sys/class/rtc/rtc*/since_epoch returns 
> correct information. So why to disable compiling driver on 
> machines where driver working?

Sounds like we need an efi=rtc_enable knob for people who what to use
it...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
