Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab3BTG6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 01:58:12 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:52607 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab3BTG6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 01:58:10 -0500
MIME-Version: 1.0
In-Reply-To: <1361300333-9410-1-git-send-email-khoroshilov@ispras.ru>
References: <1361300333-9410-1-git-send-email-khoroshilov@ispras.ru>
Date: Wed, 20 Feb 2013 12:28:09 +0530
Message-ID: <CAHFNz9+RnXh3AeSn70mpP-Z=26=MCZDtGPHnr67U++i7X6ELOA@mail.gmail.com>
Subject: Re: [PATCH] [media] stv090x: do not unlock unheld mutex in stv090x_sleep()
From: Manu Abraham <abraham.manu@gmail.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Manu Abraham <manu@linuxtv.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Feb 20, 2013 at 12:28 AM, Alexey Khoroshilov
<khoroshilov@ispras.ru> wrote:
> goto err and goto err_gateoff before mutex_lock(&state->internal->demod_lock)
> lead to unlock of unheld mutex in stv090x_sleep().

Out of curiosity, what happens when you try to unlock an unlocked mutex ?

Regards,
Manu
