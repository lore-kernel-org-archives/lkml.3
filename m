Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbaKDTVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:21:10 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:59677 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261AbaKDTVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:21:08 -0500
Message-ID: <1415128864.20372.189.camel@x220>
Subject: Re: [PATCH v3] usb: Remove references to non-existent PLAT_S5P
 symbol
From: Paul Bolle <pebolle@tiscali.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, jg1.han@samsung.com,
        linux-samsung-soc@vger.kernel.org
Date: Tue, 04 Nov 2014 20:21:04 +0100
In-Reply-To: <54591BDF.8060203@samsung.com>
References: <1412673127-11479-1-git-send-email-s.nawrocki@samsung.com>
	 <20141103232438.GA11698@kroah.com> <54591BDF.8060203@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Nov 2014 19:21:05.0306 (UTC) FILETIME=[7A8617A0:01CFF864]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-04 at 19:33 +0100, Sylwester Nawrocki wrote:
> On 04/11/14 00:24, Greg KH wrote:
> > This isn't a stable issue...
> 
> Sorry for disturbing then, let me go and read the documentation again.

If I remember correctly, I asked Sylwester to mark this for stable. So
it's me that should be educated here.

Why is a patch that allows the users of ARCH_S5PV210 to set
USB_EHCI_EXYNOS or USB_OHCI_EXYNOS - which they apparently need - for a
v3.17.y kernel, not a stable issue?


Paul Bolle

