Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab3GQQ2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:28:13 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33656 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab3GQQ2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:28:11 -0400
MIME-Version: 1.0
In-Reply-To: <51E6C455.5080907@samsung.com>
References: <1374076022-10960-1-git-send-email-prabhakar.csengg@gmail.com> <51E6C455.5080907@samsung.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 17 Jul 2013 21:57:49 +0530
Message-ID: <CA+V-a8sZxYG8hrXuF6m8w7sWYjUbnF=HQn-RK5t1jdAH0fiD0w@mail.gmail.com>
Subject: Re: [PATCH RFC FINAL v5] media: OF: add "sync-on-green-active" property
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: LMML <linux-media@vger.kernel.org>, devicetree-discuss@lists.ozlabs.org,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

On Wed, Jul 17, 2013 at 9:50 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> On 07/17/2013 05:47 PM, Prabhakar Lad wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> This patch adds 'sync-on-green-active' property as part
>> of endpoint property.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
> Thanks Prabhakar, it looks good to me.
> Just a side note, the 'From' tag above isn't needed. It wasn't
> added automatically, was it ?

Yes this was added automatically.

> Unless there are comments from others I think this patch should
> be merged together with the users of this new property.
>
> Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>
Thanks for the Ack.

--
Regards,
Prabhakar Lad
