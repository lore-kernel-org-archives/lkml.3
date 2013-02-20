Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934637Ab3BTSph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 13:45:37 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:37797 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933297Ab3BTSpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 13:45:36 -0500
MIME-Version: 1.0
In-Reply-To: <1361385853-29010-1-git-send-email-sasha.levin@oracle.com>
References: <1361385853-29010-1-git-send-email-sasha.levin@oracle.com>
Date: Wed, 20 Feb 2013 10:45:35 -0800
X-Google-Sender-Auth: 6TFXanNNRhwfGp8Uy3WP5LPgUqQ
Message-ID: <CAOS58YMT3NS-8zvwx1tNQoLKM1WtKtT-YXBPi=4pAeAMi=rYeA@mail.gmail.com>
Subject: Re: [PATCH] idr: prevent NULL deref on lookups before insertions
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Sasha.

On Wed, Feb 20, 2013 at 10:44 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
> 'hint' will be NULL if we're looking up before adding anything
> to the IDR.
>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Andy Shevchenko	already posted fix (and free_layer() needs an update too).

Thanks.

-- 
tejun
