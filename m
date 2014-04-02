Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbaDBKW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 06:22:56 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:56071 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbaDBKWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 06:22:54 -0400
MIME-Version: 1.0
In-Reply-To: <533BDAA7.5070704@xs4all.nl>
References: <1395683489-25986-1-git-send-email-prabhakar.csengg@gmail.com> <533BDAA7.5070704@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 2 Apr 2014 15:52:23 +0530
Message-ID: <CA+V-a8vM=qNpRN++p27+FtLQ2unEebdsz8FRYg4hOWTUqth-iw@mail.gmail.com>
Subject: Re: [PATCH] v4l2-pci-skeleton: fix typo while retrieving the skel_buffer
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        LDOC <linux-doc@vger.kernel.org>, Rob Landley <rob@landley.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Wed, Apr 2, 2014 at 3:08 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 03/24/14 18:51, Lad, Prabhakar wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  Documentation/video4linux/v4l2-pci-skeleton.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/Documentation/video4linux/v4l2-pci-skeleton.c b/Documentation/video4linux/v4l2-pci-skeleton.c
>> index 3a1c0d2..61a56f4 100644
>> --- a/Documentation/video4linux/v4l2-pci-skeleton.c
>> +++ b/Documentation/video4linux/v4l2-pci-skeleton.c
>> @@ -87,7 +87,7 @@ struct skel_buffer {
>>
>>  static inline struct skel_buffer *to_skel_buffer(struct vb2_buffer *vb2)
>>  {
>> -     return container_of(vb2, struct skel_buffer, vb);
>> +     return container_of(vb2, struct skel_buffer, vb2);
>
> Why is this a type? The vb2_buffer member in struct skel_buffer is called
> 'vb', so this should be correct.
>
Oops may be I overlooked, sorry for the noise.

Thanks,
--Prabhakar Lad
