Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaA3GCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 01:02:35 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:49399 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaA3GCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 01:02:33 -0500
MIME-Version: 1.0
In-Reply-To: <1391060563-27015-1-git-send-email-amit.grover@samsung.com>
References: <52E0ED10.2020901@samsung.com>
	<1391060563-27015-1-git-send-email-amit.grover@samsung.com>
Date: Thu, 30 Jan 2014 11:32:32 +0530
Message-ID: <CAK9yfHzMk=NyC942z6mGFm6M--AZ7Tkq8q__MfvBGOnNrJ5vyA@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] drivers/media: Add controls for Horizontal and
 Vertical MV Search Range
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Amit Grover <amit.grover@samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>, hans.verkuil@cisco.com,
        Hans Verkuil <hverkuil@xs4all.nl>, swaminath.p@samsung.com,
        "jtp.park@samsung.com" <jtp.park@samsung.com>, Rrob@landley.net,
        andrew.smirnov@gmail.com, anatol.pomozov@gmail.com,
        jmccrohan@gmail.com, Joe Perches <joe@perches.com>,
        awalls@md.metrocast.net, Arun Kumar <arun.kk@samsung.com>,
        austin.lobo@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

On 30 January 2014 11:12, Amit Grover <amit.grover@samsung.com> wrote:
> Based on 'master' branch of Linux-next.

Kamil's tree [1] would be more current most of the times for this driver.

[1] git://linuxtv.org/kdebski/media.git


> This is v2 version for the patch:
> s5p-mfc: Add Horizontal and Vertical search range for Video Macro Blocks
> (https://lkml.org/lkml/2013/12/30/83)
>
> Changes from v1:
> 1) Splitted the patch into v4l2 and mfc driver patches.
> 2) Incorporated review comments of v1
>
> Amit Grover (2):
>   drivers/media: v4l2: Add settings for Horizontal and Vertical MV
>     Search Range
>   drivers/media: s5p-mfc: Add Horizontal and Vertical MV Search Range

nit: media changes use the following title format:
[media] v4l2: Add settings for Horizontal and Vertical MV Search Range
[media] s5p-mfc: Add Horizontal and Vertical MV Search Range



-- 
With warm regards,
Sachin
