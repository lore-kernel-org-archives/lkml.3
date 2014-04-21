Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbaDUVFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 17:05:35 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:33786 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbaDUVFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 17:05:30 -0400
MIME-Version: 1.0
In-Reply-To: <1353509071-8658-1-git-send-email-grant.likely@secretlab.ca>
References: <1353509071-8658-1-git-send-email-grant.likely@secretlab.ca>
Date: Mon, 21 Apr 2014 16:05:29 -0500
Message-ID: <CAL_JsqJFM1e2Y7GykK06KuZ8fD8iZ=64W1i+tqibJ9datCUR0Q@mail.gmail.com>
Subject: Re: [RFC] driver-core: Remove dummy 'platform_bus'
From: Rob Herring <robherring2@gmail.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 8:44 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> The "platform_bus" (note: not platform_bus_type) only exists as an empty
> directory to put platform devices into. However, it really doesn't make
> sense to segregate all the platform devices into a sub directory when
> typically they are memory mapped devices that doen't go through any
> particular bus. Particularly on embedded type platforms the platform_bus
> directory doesn't add anything.
>
> However, this will probably just end up breaking some userspace that
> depends on the /sys/devices/platform/ path to be present (no matter how
> much we protest that userspace must not depend on paths in sysfs). So
> while I'm seriously proposing this change, it may just be unacceptable
> ABI breakage

An old thread, but was there ever a conclusion to this? We now have a
mixture of using platform_bus as the parent or not on various ARM
platforms.

Rob
