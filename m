Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966154Ab3E2TP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 15:15:26 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:61467 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965810Ab3E2TPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 15:15:19 -0400
MIME-Version: 1.0
In-Reply-To: <1369827913-31033-1-git-send-email-n.a.balandin@gmail.com>
References: <1369827913-31033-1-git-send-email-n.a.balandin@gmail.com>
Date: Wed, 29 May 2013 22:15:17 +0300
Message-ID: <CAHp75VdmKih7VLGDGMZ8CNCzWFE38TC-sUZOGvq-yqFN1YmkDA@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] drivers/misc: lis3lv02d: convert to use devm_regulator_bulk_get
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Nikolay Balandin <n.a.balandin@gmail.com>
Cc: Eric Piel <eric.piel@tremplin-utc.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nikolay Balandin <nbalandin@dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 2:45 PM, Nikolay Balandin
<n.a.balandin@gmail.com> wrote:
> From: Nikolay Balandin <nbalandin@dev.rtsoft.ru>
>
> Use devm_regulator_bulk_get to make cleanup paths simpler

Do you plan to use this driver somewhere outside of Nokia n900 device?
If so, there is more than this clean up to do.

Otherwise I don't think we have to touch that driver at all.

--
With Best Regards,
Andy Shevchenko
