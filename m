Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762667Ab3DCMaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:30:25 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:33414 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761757Ab3DCMaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:30:20 -0400
MIME-Version: 1.0
In-Reply-To: <CACQ1gAhL8q_-4vJ=ivLQ=bbt5k9QHDd5dtKLWoXT8DsM0MFa0A@mail.gmail.com>
References: <1364222843-30305-1-git-send-email-richard.genoud@gmail.com>
	<1364222843-30305-4-git-send-email-richard.genoud@gmail.com>
	<5153859A.8000801@wwwdotorg.org>
	<CACQ1gAjEUsCuFThzAfoX3-PHn3h70=qw+uktHNd9cQDWeQZ1Jw@mail.gmail.com>
	<5154594D.6000103@wwwdotorg.org>
	<CACQ1gAhL8q_-4vJ=ivLQ=bbt5k9QHDd5dtKLWoXT8DsM0MFa0A@mail.gmail.com>
Date: Wed, 3 Apr 2013 14:30:19 +0200
Message-ID: <CACRpkdZw_hM2CYJENuJnzEgKLN10GqTvNvXj0cZ+3yFeY_kmcQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] pinctrl: disable and free setting in select_state in
 case of error
From: Linus Walleij <linus.walleij@linaro.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 4:47 PM, Richard Genoud
<richard.genoud@gmail.com> wrote:
> 2013/3/28 Stephen Warren <swarren@wwwdotorg.org>:

>> Again, pinconf_free_setting() is all about freeing any dynamically
>> allocated storage required to represent the setting itself; it's not
>> about (un-)programming HW.
>>
> got it.
> I'll change that

I guess the incremental patches have fixed most issues pointed out
in this thread? Elese keep the add-on patches coming, as long as the
end result looks OK to both of you I'm happy too.

Yours,
Linus Walleij
