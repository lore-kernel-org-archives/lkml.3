Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab3FRENo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 00:13:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53588 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab3FRENn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 00:13:43 -0400
MIME-Version: 1.0
In-Reply-To: <20130618040547.GB12181@roeck-us.net>
References: <1371285398-18566-1-git-send-email-ming.lei@canonical.com>
	<20130617235915.GA19162@kroah.com>
	<CACVXFVNahZpH-FdZ=NJ1HZybDCSuoV2aZM2--gBVMD22FVBJcQ@mail.gmail.com>
	<20130618040547.GB12181@roeck-us.net>
Date: Tue, 18 Jun 2013 12:13:40 +0800
Message-ID: <CACVXFVMq=qQ=BwghbULPb9rLuBaPHRvg_-f80ykhiod0gJ34JA@mail.gmail.com>
Subject: Re: [PATCH] firmware loader: fix use-after-free by double abort
From: Ming Lei <ming.lei@canonical.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        nirinA raseliarison <nirina.raseliarison@gmail.com>,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 12:05 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>>
> I may be missing something, but why would mainline not need it ?
> Or do you mean "mainline plus 3.9" ?

Yes, mainline need it of course, sorry for not mentioning that explicitly.

Thanks,
--
Ming Lei
