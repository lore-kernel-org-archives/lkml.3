Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaBZEMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 23:12:40 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:49683 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaBZEMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 23:12:38 -0500
MIME-Version: 1.0
In-Reply-To: <1393382688-5429-1-git-send-email-pankaj.dubey@samsung.com>
References: <1393382688-5429-1-git-send-email-pankaj.dubey@samsung.com>
Date: Wed, 26 Feb 2014 09:42:37 +0530
Message-ID: <CAK9yfHyjQmFnJaM0v638X-K+jHveofOkf=2bWQ9-cyQ1y39Hmw@mail.gmail.com>
Subject: Re: [PATCH] clk: samsung: remove parentheses from return statements
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>, Mike Turquette <mturquette@linaro.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 26 February 2014 08:14, Pankaj Dubey <pankaj.dubey@samsung.com> wrote:
> fixed following checkpatch warning message
> "return is not a function, parentheses are not required"
>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>

Similar patch has already been submitted:
http://comments.gmane.org/gmane.linux.ports.arm.kernel/294530


-- 
With warm regards,
Sachin
