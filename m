Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab3JWI4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 04:56:43 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:51307 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab3JWI4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 04:56:41 -0400
MIME-Version: 1.0
In-Reply-To: <1382347034-32332-1-git-send-email-sachin.kamat@linaro.org>
References: <1382347034-32332-1-git-send-email-sachin.kamat@linaro.org>
Date: Wed, 23 Oct 2013 10:56:40 +0200
Message-ID: <CACRpkdant-GmSwRYQDPntAR9AL4LKfmTp52=tiL=EKYz1CDF_A@mail.gmail.com>
Subject: Re: [PATCH 1/1] pinctrl: mvebu: remove redundant of_match_ptr
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Simon Guinot <simon.guinot@sequanux.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 11:17 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> The data structure of_match_ptr() protects is always compiled in.
> Hence of_match_ptr() is not needed.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Patch applied.

Yours,
Linus Walleij
