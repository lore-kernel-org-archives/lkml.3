Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbaFXPx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:53:27 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:56450 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbaFXPxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:53:18 -0400
MIME-Version: 1.0
In-Reply-To: <1403558406-14519-1-git-send-email-dianders@chromium.org>
References: <1403558406-14519-1-git-send-email-dianders@chromium.org>
Date: Tue, 24 Jun 2014 09:53:17 -0600
X-Google-Sender-Auth: rip6J6N1CSNmKW0vzg-Oesx8yD4
Message-ID: <CAPnjgZ2_T46YgQnS1WvG7Wf8oPREuZmayE+_JkTzuEUVtAA=OA@mail.gmail.com>
Subject: Re: [PATCH] i2c: cros_ec: Remove EC_I2C_FLAG_10BIT
From: Simon Glass <sjg@chromium.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Lee Jones <lee.jones@linaro.org>,
        Dave Jones <davej@redhat.com>,
        Randall Spangler <rspangler@chromium.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Bill Richardson <wfrichar@chromium.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        lk <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 June 2014 15:20, Doug Anderson <dianders@chromium.org> wrote:
> In <https://lkml.org/lkml/2014/6/10/265> pointed out that the 10-bit
> flag in the cros_ec_tunnel was useless.  It went into a 16-bit flags
> field but was defined at (1 << 16).
>
> Since we have no 10-bit i2c devices on the other side of the tunnel on
> any known devices this was never a problem.  Until we do it makes
> sense to remove this code.  On the EC side the code to handle this
> flag was removed in <https://chromium-review.googlesource.com/204162>.
>
> Reported-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Funny. We certainly don't use it.

Reviewed-by: Simon Glass <sjg@chromium.org>

Regards,
Simon
