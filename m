Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab3I1UOg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 16:14:36 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53017 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab3I1UOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 16:14:34 -0400
MIME-Version: 1.0
In-Reply-To: <1380337550.27811.71.camel@pasglop>
References: <1380270519.27811.10.camel@pasglop>
	<CAE9FiQVkW7d7vFx_kPJG-FEvO71SZjZmpR+dnwVm61wkYK=0YA@mail.gmail.com>
	<CA+55aFyDfMdAeaniQwkoeW6F-xd3JxrzGYwtFb6N9+NA6aRCMg@mail.gmail.com>
	<1380318405.27811.37.camel@pasglop>
	<CAE9FiQXXvkfTak6oEpUog_RYs_Gwpdji7N5UJ=R11Q61==N97A@mail.gmail.com>
	<1380321480.27811.53.camel@pasglop>
	<CAE9FiQWm7ALPO5k_2nV+fuZw4oNNiw+_PEx8EWkb52ymN+EYUg@mail.gmail.com>
	<1380323960.27811.67.camel@pasglop>
	<CAE9FiQV8ipnQ_vV68S-QHMrUrQTWQT_XObxyBeR=dOuw6fG1eg@mail.gmail.com>
	<1380337550.27811.71.camel@pasglop>
Date: Sat, 28 Sep 2013 13:14:33 -0700
X-Google-Sender-Auth: 5lfB7zZr5MsGXuODEjGIhmFOzbA
Message-ID: <CAE9FiQUnwmANf5x8rw5=QViyVPdi0FLMpSGGnO9u-Twp_YXMpg@mail.gmail.com>
Subject: Re: Please revert 928bea964827d7824b548c1f8e06eccbbc4d0d7d
From: Yinghai Lu <yinghai@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 8:05 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Fri, 2013-09-27 at 16:44 -0700, Yinghai Lu wrote:
>
> In the meantime, can you properly submit the other one with the warning
> to Linus ? It will make things more robust overall...

https://patchwork.kernel.org/patch/2959121/
