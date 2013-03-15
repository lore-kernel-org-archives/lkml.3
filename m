Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab3CODPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 23:15:53 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:47049 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab3CODPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 23:15:51 -0400
MIME-Version: 1.0
In-Reply-To: <29811710.141161363307438813.JavaMail.weblogic@epv6ml07>
References: <29811710.141161363307438813.JavaMail.weblogic@epv6ml07>
Date: Thu, 14 Mar 2013 20:15:49 -0700
X-Google-Sender-Auth: oMj8XI6UlNOAtgJ9eFUMxiNnshM
Message-ID: <CAD=FV=U5wiLnW_tYaaA8Nq7Y=wzTwckMkSDEJY1ZvwOY0=an9Q@mail.gmail.com>
Subject: Re: [PATCH] usb: ehci-s5p: Use devm for requesting ehci_vbus_gpio
From: Doug Anderson <dianders@chromium.org>
To: jg1.han@samsung.com
Cc: Felipe Balbi <balbi@ti.com>, Alexander Graf <agraf@suse.de>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jingoo,

On Thu, Mar 14, 2013 at 5:30 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> Would you replace other '&pdev->dev' with 'dev' in s5p_setup_vbus_gpio()
> as below? It seems to be better for readability.

Yes, of course.  That was silly of me not to add the "dev" local and
not update the other places...  Thanks for your review!

-Doug
