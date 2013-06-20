Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965569Ab3FTTWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 15:22:50 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:52126 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965163Ab3FTTWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 15:22:48 -0400
MIME-Version: 1.0
In-Reply-To: <1371753290.2146.35.camel@joe-AO722>
References: <1371753290.2146.35.camel@joe-AO722>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Thu, 20 Jun 2013 12:22:28 -0700
Message-ID: <CAHGf_=qo09Qxja8v2ORShi3kvv4z1Zk-nGPLR9k0UA3Car1xLA@mail.gmail.com>
Subject: Re: [PATCH] mm: remove unused VM_<READfoo> macros and expand other in-place
To: Joe Perches <joe@perches.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 11:34 AM, Joe Perches <joe@perches.com> wrote:
> These VM_<READfoo> macros aren't used very often and
> three of them aren't used at all.
>
> Expand the ones that are used in-place, and remove
> all the now unused #define VM_<foo> macros.
>
> VM_READHINTMASK, VM_NormalReadHint and VM_ClearReadHint
> were added just before 2.4 and appears have never been used.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> Found by looking for CamelCase variable name exceptions

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
