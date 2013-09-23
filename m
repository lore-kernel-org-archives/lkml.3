Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab3IWDwZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 23:52:25 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:61202 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab3IWDwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 23:52:24 -0400
MIME-Version: 1.0
In-Reply-To: <1379775649-6331-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1379775649-6331-1-git-send-email-m.krawczuk@partner.samsung.com>
Date: Mon, 23 Sep 2013 09:22:23 +0530
Message-ID: <CAK9yfHw2LZmKjMd7Auz=hWeRMkvoOUEVEZknpg3OJcWhqo4Rtw@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] media: s5p-tv: clean-up and fixes
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: m.chehab@samsung.com, Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, b.zolnierkie@samsung.com,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mateusz,

On 21 September 2013 20:30, Mateusz Krawczuk
<m.krawczuk@partner.samsung.com> wrote:
> This patch series add restoring previous vpll rate after driver offs stream
> or recives error.
> It also replace mxr_info, mxr_dbg, mxr_warn and mxr_err macro
> by generic solution.

It is a good practice to include revision history of the changes in
the patch set. This will help reviewers
check if the changes previously suggested have been incorporated or
not and to identify any new changes introduced by the author.


-- 
With warm regards,
Sachin
