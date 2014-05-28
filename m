Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbaE1V7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:59:39 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:57538 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaE1V7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:59:38 -0400
MIME-Version: 1.0
In-Reply-To: <CA+BWVURydjyrnC9ec-POtn5A8gL7C93MH6pObcmmAqD4V=p0Zg@mail.gmail.com>
References: <1401311175-12784-1-git-send-email-reyad.attiyat@gmail.com>
 <1401311175-12784-4-git-send-email-reyad.attiyat@gmail.com>
 <CA+BWVUQEsprV1jEzD9D0hidR0jvYeSRVGT=ESzstR4apa+nV1A@mail.gmail.com>
 <53865438.2030901@linux.intel.com> <CA+BWVUT6tC5nn--zUJ83+FvtQ-AAtZ+CmyUN0bnTEuffpTRD2Q@mail.gmail.com>
 <53865B83.8030505@linux.intel.com> <CA+BWVURydjyrnC9ec-POtn5A8gL7C93MH6pObcmmAqD4V=p0Zg@mail.gmail.com>
From: Reyad Attiyat <reyad.attiyat@gmail.com>
Date: Wed, 28 May 2014 16:59:16 -0500
Message-ID: <CA+BWVUR0VJCbi99AEo4v_ZGcPeG_uzjYdr2LUROshUhzzKADsw@mail.gmail.com>
Subject: Fwd: [PATCH 3/3] IO: hid-sensor-magn-3d: Add in support for
 True/Magnetic North HID usages
To: linux-kernel@vger.kernel.org, linux-input <linux-input@vger.kernel.org>,
        linux-iio@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to forward to list


---------- Forwarded message ----------
From: Reyad Attiyat <reyad.attiyat@gmail.com>
Date: Wed, May 28, 2014 at 4:57 PM
Subject: Re: [PATCH 3/3] IO: hid-sensor-magn-3d: Add in support for
True/Magnetic North HID usages
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>


Hey Srinivas,

> It shouldn't be an issue for few more attributes. The idea is that
> we don't expose the report level parsing information to the client drivers.
> The client shouldn't worry about which collection or report it belongs to.
>
Makes sense.

> In this way if we have to enhance the parse function for newer
> FW changes or quirks, it is only done at one place. Clients are not
> affected at all.
>
> Alternatively
> we can enhance API, which takes multiple usage ids and fills information
> in a single call. What do you think about this?

Yes this seems like a great idea. I will try and implement this and
resubmit these patches.

Thank You,
Reyad Attiyat
