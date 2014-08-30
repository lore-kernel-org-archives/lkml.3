Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaH3Lox (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 07:44:53 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:64976 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaH3Lov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 07:44:51 -0400
MIME-Version: 1.0
In-Reply-To: <1408461959-29660-1-git-send-email-daniel.baluta@intel.com>
References: <1408461959-29660-1-git-send-email-daniel.baluta@intel.com>
Date: Sat, 30 Aug 2014 14:44:49 +0300
X-Google-Sender-Auth: k9iQu8I6TlKHsJn9C8cQxZwNLdE
Message-ID: <CAEnQRZBHKbnKPe7raezXNzHovepRW4eJ4D33ZqVZMxP5o51PMQ@mail.gmail.com>
Subject: Re: [PATCH] iio: accel: kxcjk-1013: add support for kxcj9-1008
From: Daniel Baluta <daniel.baluta@intel.com>
To: Daniel Baluta <daniel.baluta@intel.com>,
        Jonathan Cameron <jic23@kernel.org>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>,
        swarren@nvidia.com, Peter Meerwald <pmeerw@pmeerw.net>,
        linux-iio@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 6:25 PM, Daniel Baluta <daniel.baluta@intel.com> wrote:
> This patch adds support for KXCJ9-1008 3-axis acceleromenter sensor.
> KXCJ9-1008 uses the same register definitions as KXCJK-1013.
>
> The specification for KXCJ9-1008 can be downloaded from:
> http://www.kionix.com/sites/default/files/KXCJ9-1008%20Specifications%20Rev%205.pdf
>
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>

Hi Jonathan,

Any comments on this?

On Monday I will send a patch that adds support  KXTJ2-1009 and its
based on this patch.
I can squash them together if you want.

Daniel.
