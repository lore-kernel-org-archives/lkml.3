Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaKDTxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:53:00 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:64560 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752298AbaKDTw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:52:58 -0500
Message-ID: <1415130776.20372.194.camel@x220>
Subject: Re: [PATCH v3] usb: Remove references to non-existent PLAT_S5P
 symbol
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, jg1.han@samsung.com,
        linux-samsung-soc@vger.kernel.org
Date: Tue, 04 Nov 2014 20:52:56 +0100
In-Reply-To: <20141104194221.GB3722@kroah.com>
References: <1412673127-11479-1-git-send-email-s.nawrocki@samsung.com>
	 <20141103232438.GA11698@kroah.com> <54591BDF.8060203@samsung.com>
	 <1415128864.20372.189.camel@x220> <20141104194221.GB3722@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Nov 2014 19:52:56.0463 (UTC) FILETIME=[EDA981F0:01CFF868]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-04 at 11:42 -0800, Greg KH wrote:
> As it's something that no one seemed to ever need before (i.e. it's not
> a regression fix), but it would be a "new feature", I don't think it's
> really a stable fix.
> 
> But feel free to convince me otherwise :)

Sylwester, was I right in thinking that users of PLAT_S5P, who could set
USB_EHCI_EXYNOS or USB_OHCI_EXYNOS pre v3.17, got, well, transferred to
ARCH_S5PV210 and lost the ability to set one of those symbols in v3.17?


Paul Bolle

