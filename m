Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab3A0Nv2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 08:51:28 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:56221 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726Ab3A0Nv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 08:51:26 -0500
MIME-Version: 1.0
In-Reply-To: <1359080658.4232.6.camel@phoenix>
References: <1359080429.4232.3.camel@phoenix>
	<1359080658.4232.6.camel@phoenix>
Date: Sun, 27 Jan 2013 19:21:25 +0530
Message-ID: <CAKew6eXPMQ6gYg3Ed5S_kjFfifK22Kp3LQ8DimD1_35rCHpJPQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] regulator: max77686: Fix using wrong dev argument at
 various places
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 7:54 AM, Axel Lin <axel.lin@ingics.com> wrote:
> Use &pdev->dev rather than iodev->dev for dev_err().
> Use &pdev->dev rather than iodev->dev for devm_kzalloc() and
> of_regulator_match(), this fixes memory leak.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---

Reviewed-by: Yadwinder Singh Brar <yadi.brar@samsung.com>

Thanks.
