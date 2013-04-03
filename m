Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762367Ab3DCMhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:37:05 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:57447 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759408Ab3DCMhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:37:02 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZw_hM2CYJENuJnzEgKLN10GqTvNvXj0cZ+3yFeY_kmcQ@mail.gmail.com>
References: <1364222843-30305-1-git-send-email-richard.genoud@gmail.com>
 <1364222843-30305-4-git-send-email-richard.genoud@gmail.com>
 <5153859A.8000801@wwwdotorg.org> <CACQ1gAjEUsCuFThzAfoX3-PHn3h70=qw+uktHNd9cQDWeQZ1Jw@mail.gmail.com>
 <5154594D.6000103@wwwdotorg.org> <CACQ1gAhL8q_-4vJ=ivLQ=bbt5k9QHDd5dtKLWoXT8DsM0MFa0A@mail.gmail.com>
 <CACRpkdZw_hM2CYJENuJnzEgKLN10GqTvNvXj0cZ+3yFeY_kmcQ@mail.gmail.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Wed, 3 Apr 2013 14:36:41 +0200
Message-ID: <CACQ1gAgHFpE3keS5_Wxwe4i2mTnnvT0VdwGJgVtW_6GCBmf1DA@mail.gmail.com>
Subject: Re: [PATCH 3/4] pinctrl: disable and free setting in select_state in
 case of error
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/3 Linus Walleij <linus.walleij@linaro.org>:
> On Thu, Mar 28, 2013 at 4:47 PM, Richard Genoud
> <richard.genoud@gmail.com> wrote:
>> 2013/3/28 Stephen Warren <swarren@wwwdotorg.org>:
>
>>> Again, pinconf_free_setting() is all about freeing any dynamically
>>> allocated storage required to represent the setting itself; it's not
>>> about (un-)programming HW.
>>>
>> got it.
>> I'll change that
>
> I guess the incremental patches have fixed most issues pointed out
> in this thread? Elese keep the add-on patches coming, as long as the
> end result looks OK to both of you I'm happy too.
Yes, I think we've covered it all.
Tthe last patches are:
[PATCH 1/2] pinctrl: select_state: don't call pinctrl_free_setting on error
[PATCH 2/2] pinctrl: simplify the re-enable old state code in
pinctrl_select_state
(sent and reviewed on 29 march.)

Best regards,
Richard.
