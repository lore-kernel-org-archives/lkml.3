Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbaFDPX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:23:57 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:61589 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaFDPXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:23:54 -0400
MIME-Version: 1.0
In-Reply-To: <538E092F.9040004@linux.intel.com>
References: <1401750890-31854-1-git-send-email-reyad.attiyat@gmail.com>
 <1401750890-31854-4-git-send-email-reyad.attiyat@gmail.com> <538E092F.9040004@linux.intel.com>
From: Reyad Attiyat <reyad.attiyat@gmail.com>
Date: Wed, 4 Jun 2014 10:23:32 -0500
Message-ID: <CA+BWVUTxnS_C+EXm1SuShywk998+E5KfTdtTrS6_a0+k+4U4ig@mail.gmail.com>
Subject: Re: [PATCHv2 3/3] IIO: hid-sensor-magn-3d: Add in support for
 True/Magnetic North HID usages
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        linux-input <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Srinivas,

On Tue, Jun 3, 2014 at 12:43 PM, Srinivas Pandruvada
<srinivas.pandruvada@linux.intel.com> wrote:

>
> May be we should have a field in const struct iio_chan_spec, so that we
> can dynamically enable disable channels. In this way we can statically
> define channels, but can be enabled/disabled dynamically.
>
Would this require changing iio subsystem to create sysfs entries only
when enabled? Would we need to add functions to disable and enable
later on?
>
> I think we need to present angle in radians. Are you basing change present
> in linux-next? This will automatically do in this function.
>
I'll look into this. What function should I use to make the iio chanel
to report radians?
>
>
> I don't see kfree. Try devm_kcalloc?
>
I changed kmemdup to kcalloc so there is still a kfree in the exsiting
code. I can change this to devm_kcalloc but only if we don't go with
static channels that are enabled as found.

Thanks,
Reyad Attiyat
