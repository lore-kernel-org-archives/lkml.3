Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab3JCQqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:46:32 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:49385 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab3JCQqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:46:31 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <BC1C47B3-5412-4829-A1D9-AAB04694D1CC@codeaurora.org>
References: <BC1C47B3-5412-4829-A1D9-AAB04694D1CC@codeaurora.org>
Date: Thu, 3 Oct 2013 09:46:30 -0700
Message-ID: <CAOesGMjJ6Uj0uGFJqtnWQyDW+tr6eLVWoHZ+B7uFna+L8N6E8Q@mail.gmail.com>
Subject: Re: Use of drivers/platform and matching include?
From: Olof Johansson <olof@lixom.net>
To: Kumar Gala <galak@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 7:45 AM, Kumar Gala <galak@codeaurora.org> wrote:
> As we look at upstreaming more support for the Qualcomm MSM SoCs there are a number of drivers or library like routines that are unique to the MSM platform, we are thinking that putting them under:
>
> drivers/platform/qcom/

drivers/platform has traditionally been used for OEM/product platform
drivers, i.e. stuff such as laptop drivers or server management module
drivers, i.e. not platforms in "SoC family" sense.

I don't have a good answer though. If it wasn't for the arm64 fork,
locating these under arch/arm somewhere would really be the reasonable
answer, like we used to do on powerpc. :(


-Olof
