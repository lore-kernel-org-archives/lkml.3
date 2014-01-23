Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbaAWFnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 00:43:18 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:58260 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaAWFnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 00:43:15 -0500
MIME-Version: 1.0
In-Reply-To: <DA6097ED98694425932A6AF93513371A@sisodomain.com>
References: <1388400186-22045-1-git-send-email-amit.grover@samsung.com> <DA6097ED98694425932A6AF93513371A@sisodomain.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 23 Jan 2014 11:12:54 +0530
Message-ID: <CA+V-a8uQAeY1zM+YVWi7QXPSPwAEhD=Gds-15sk+e9VbaNN98g@mail.gmail.com>
Subject: Re: [PATCH] [media] s5p-mfc: Add Horizontal and Vertical search range
 for Video Macro Blocks
To: swaminathan <swaminath.p@samsung.com>
Cc: Amit Grover <amit.grover@samsung.com>,
        linux-media <linux-media@vger.kernel.org>,
        LDOC <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>, anatol.pomozov@gmail.com,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>, austin.lobo@samsung.com,
        jmccrohan@gmail.com, arun.kk@samsung.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Swaminathan,

On Thu, Jan 23, 2014 at 10:49 AM, swaminathan <swaminath.p@samsung.com> wrote:
> Hi All,
> Is there any review Comments for the patch "[PATCH] [media] s5p-mfc: Add
> Horizontal and Vertical search range for Video Macro Blocks"
> posted on 30-Dec-2013 ?
>
>
Just a side note, please don’t top post and always reply as plain text.

[Snip]

> Subject: [PATCH] [media] s5p-mfc: Add Horizontal and Vertical search range
> for Video Macro Blocks
>
>
>> This patch adds Controls to set Horizontal and Vertical search range
>> for Motion Estimation block for Samsung MFC video Encoders.
>>
>> Signed-off-by: Swami Nathan <swaminath.p@samsung.com>
>> Signed-off-by: Amit Grover <amit.grover@samsung.com>
>> ---
>> Documentation/DocBook/media/v4l/controls.xml    |   14 +++++++++++++
>> drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    2 ++
>> drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   24
>> +++++++++++++++++++++++
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    8 ++------
>> drivers/media/v4l2-core/v4l2-ctrls.c            |   14 +++++++++++++
>> include/uapi/linux/v4l2-controls.h              |    2 ++
>> 6 files changed, 58 insertions(+), 6 deletions(-)
>>
This patch from the outset looks OK,  but you need to split up
into two, first adding a v4l control and second one using it up in the driver.

Regards,
--Prabhakar Lad
