Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936903Ab3DJO5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 10:57:16 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:53949 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936826Ab3DJO5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 10:57:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130410093039.GA24443@gmail.com>
References: <1365512532-18730-1-git-send-email-epure.andrei@gmail.com>
	<20130410093039.GA24443@gmail.com>
Date: Wed, 10 Apr 2013 17:57:14 +0300
Message-ID: <CAEqtziEXX7hgsgyjDHdWaypw==nLRjTPz7EX-FQuCS4ECjCjQA@mail.gmail.com>
Subject: Re: [PATCH] include:linux: task_struct personality comment
From: Andrei Epure <epure.andrei@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 April 2013 12:30, Ingo Molnar <mingo@kernel.org> wrote:
>
> I don't mind documenting the p->personality flag, but in practice it's not used
> for emulation of other OSs really, but for emulating ABI behavior with previous
> _Linux_ versions, see include/uapi/linux/personality.h:
>
>
> So the updated comment should say that.
>

Ok, thanks, I will send a v2.

Andrei



--
Andrei Epure
