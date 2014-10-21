Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276AbaJUQoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:44:07 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:47415 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769AbaJUQoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:44:05 -0400
MIME-Version: 1.0
In-Reply-To: <1413909608.12828.5.camel@perches.com>
References: <1413902024-2932-1-git-send-email-fabio.estevam@freescale.com>
	<1413909608.12828.5.camel@perches.com>
Date: Tue, 21 Oct 2014 14:44:03 -0200
Message-ID: <CAOMZO5BjP=o0EsQJoA_ddYYPGJhY1tUVy6mbA1_tGhd2VUJFEw@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: Improve warning message for "needless if" case
From: Fabio Estevam <festevam@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 2:40 PM, Joe Perches <joe@perches.com> wrote:

>
> Mixing sentences with and without periods is jarring.
> I'd prefer a comma or a dash.

Or what about?

"is safe and this check is probably not required"
