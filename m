Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaCHCav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 21:30:51 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:59941 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaCHCau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 21:30:50 -0500
MIME-Version: 1.0
In-Reply-To: <20140305043858.GA2494@kroah.com>
References: <1393991871-1743-1-git-send-email-roland@kernel.org>
	<20140305040929.GA31130@kroah.com>
	<CAG4TOxONSsyokdy9Sw+fT21QA7E-uY572ZDoNf3V9f7D1ytyxQ@mail.gmail.com>
	<20140305043858.GA2494@kroah.com>
Date: Fri, 7 Mar 2014 18:30:49 -0800
Message-ID: <CADyApD0hi3QoTPNoJKi0k-MQdF557BkU=MfBNDgUiAxPGfJ_Cg@mail.gmail.com>
Subject: Re: [PATCH] Revert "driver core: synchronize device shutdown"
From: Arjan van de Ven <arjanvandeven@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Roland Dreier <roland@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>, shli@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> AFAICT the synchronization does nothing useful and is just a remnant
>> of a patch series where the real meat didn't get applied.  But of
>> course it would be great if Shaohua could confirm my understanding.
>
> Shaohua's email address seems to now bounce :(
>
> Arjan, any thoughts?


if there are no users, it should go... all it does it slows down the shutdown.
