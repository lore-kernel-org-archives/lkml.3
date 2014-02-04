Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935052AbaBDWZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:25:24 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:50254 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933892AbaBDVIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:08:20 -0500
MIME-Version: 1.0
In-Reply-To: <20140204080709.GB1428@redhat.com>
References: <20140203113900.GD1725@redhat.com>
	<52F00653.40802@wwwdotorg.org>
	<20140204080105.GA1428@redhat.com>
	<20140204080709.GB1428@redhat.com>
Date: Tue, 4 Feb 2014 22:08:19 +0100
Message-ID: <CACRpkdanesMMZJ046wws5GoOLK9hgh29rHXQ0-uPKC9rTxjzsw@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: protect pinctrl_list add
From: Linus Walleij <linus.walleij@linaro.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        Patrice Chotard <patrice.chotard@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 9:07 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> We have few fedora bug reports about list corruption on pinctrl,
> for example:
> https://bugzilla.redhat.com/show_bug.cgi?id=1051918
>
> Most likely corruption happen due lack of protection of pinctrl_list
> when adding new nodes to it. Patch corrects that.
>
> Fixes: 42fed7ba44e ("pinctrl: move subsystem mutex to pinctrl_dev struct")
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> I only compile tested patch, also did not get test results from bug
> reporters yet. But I'm pretty confident that patch fixes the problem
> and does not cause any other deadlock.
>
> v1 -> v2: point correct first bad commit.

Patch applied. Thanks for bringing this to our attention!

Yours,
Linus Walleij
