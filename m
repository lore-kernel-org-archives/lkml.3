Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaLJIT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 03:19:58 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:58265 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbaLJIT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 03:19:57 -0500
MIME-Version: 1.0
In-Reply-To: <1418186307-1259-1-git-send-email-mpe@ellerman.id.au>
References: <1418186307-1259-1-git-send-email-mpe@ellerman.id.au>
From: Namhyung Kim <namhyung@kernel.org>
Date: Wed, 10 Dec 2014 17:19:36 +0900
X-Google-Sender-Auth: GAKrQ7sM84OOiSYChj0ctm--0lQ
Message-ID: <CAM9d7cgY6t7_XB+SryQft_BA0zbtcKN1ZrfQ-qONtb-SkB89Jw@mail.gmail.com>
Subject: Re: [PATCH] ftracetest: Replace usleep with sleep 0.000001
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Wed, Dec 10, 2014 at 1:38 PM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> usleep is a Fedoraism, it's not generally available on Debian based
> systems AFAICS.
>
> GNU sleep accepts a floating point argument, so use that instead.

I tested it on busybox not Debian, sorry.  But it seems busybox's
sleep doesn't support floating point argument..

  / # ls -l `which sleep`
  lrwxrwxrwx     1  root     rooot       7 May 22  2014  /bin/sleep -> busybox

  / # sleep 0.1
  sleep: invalid number '0.1'


Thanks,
Namhyung
