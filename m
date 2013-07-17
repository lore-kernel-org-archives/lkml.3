Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab3GQHDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 03:03:09 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:34223 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab3GQHDE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 03:03:04 -0400
MIME-Version: 1.0
In-Reply-To: <20130716191030.GA31335@pengutronix.de>
References: <20130716191030.GA31335@pengutronix.de>
Date: Wed, 17 Jul 2013 10:03:02 +0300
X-Google-Sender-Auth: 6xfQBdsPPovx2fxeM2IHqagSkfw
Message-ID: <CAOJsxLH8KftyLyRUtAt5-UpTve36pcfnMbVK=5hayQO4RsGLvw@mail.gmail.com>
Subject: Re: configurable partial slab support on UP
From: Pekka Enberg <penberg@kernel.org>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel@pengutronix.de,
        Steven Rostedt <srostedt@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 10:10 PM, Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:
> Hello,
>
> (sorry for breaking the mail threading, but I failed to find the right
> mail to reply to.)
>
> while doing make oldconfig on an !SMP config using 3.11-rc1 I was asked
> if I want CONFIG_SLUB_CPU_PARTIAL. AFAICT this setting only affects SMP
> machines? If so I suggest to make the choice depend on SMP and treat the
> !SMP case as CONFIG_SLUB_CPU_PARTIAL=n.
>
> This was introduced in commit
>         345c905 (slub: Make cpu partial slab support configurable)

The per-CPU partial list is used on UP machines as well so the config
option does affect them. Whether or not they should be used is another
topic entirely. Christoph, Joonsoo?

                                Pekka
