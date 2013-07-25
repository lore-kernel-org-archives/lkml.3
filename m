Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab3GYFTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 01:19:49 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:64349 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab3GYFTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 01:19:46 -0400
MIME-Version: 1.0
In-Reply-To: <51F07489.7010404@gmail.com>
References: <1374646199-9398-1-git-send-email-pshah.mumbai@gmail.com> <51F07489.7010404@gmail.com>
From: Prashant Shah <pshah.mumbai@gmail.com>
Date: Thu, 25 Jul 2013 10:49:25 +0530
Message-ID: <CAD6i1fJO3geZ0vkHLsJEd+KedHkpC1OZVTJJskU2RAAKYBhhJQ@mail.gmail.com>
Subject: Re: [PATCH] Change request_irq() to use struct net_device *dev->name
To: Ryan Mallon <rmallon@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mwhitehe@redhat.com,
        kernel-mentors@selenic.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> You should also remove the definition of DRV_NAME, since it is no longer
> used. The changelog should probably mention that this will change the
> interrupt name (which appears in /proc/interrupts for example) from "wd"
> to "eth%d".
>

I will resend the patch.

Regards.
