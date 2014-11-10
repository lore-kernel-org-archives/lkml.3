Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbaKJREn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:04:43 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:45600 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbaKJREm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:04:42 -0500
Date: Mon, 10 Nov 2014 17:04:17 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Matt Fleming <matt.fleming@intel.com>, Borislav Petkov <bp@alien8.de>,
        Mark Salter <msalter@redhat.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Young <dyoung@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] rtc: Disable EFI rtc for x86
Message-ID: <20141110170417.GA17286@srcf.ucam.org>
References: <1412339576-17972-1-git-send-email-matt@console-pimps.org>
 <20141109182231.GA29337@pd.tnic>
 <1415618533.14686.239.camel@mfleming-mobl1.ger.corp.intel.com>
 <201411101723.49197@pali>
 <5460EB92.1090501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5460EB92.1090501@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 11:45:06AM -0500, Austin S Hemmelgarn wrote:

> I agree, without it you need PC CMOS RTC support to access the RTC
> on most systems, which in turn means that you have to enable the CSM
> in the EFI firmware, which is annoying cause you can't easily dual
> boot windows with secure boot when the CSM is enabled.

CMOS RTC support doesn't depend on the CSM.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
