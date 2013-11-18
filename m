Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab3KRXyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 18:54:46 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:64380 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab3KRXyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 18:54:43 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1311191029050.20131@tundra.namei.org>
References: <alpine.LRH.2.02.1311071146450.31522@tundra.namei.org>
	<CA+5PVA7C-SSg5TyQ14kUN2SbLi-=bk6isi05xgtR5j8MC7-Uhg@mail.gmail.com>
	<alpine.LRH.2.02.1311191029050.20131@tundra.namei.org>
Date: Mon, 18 Nov 2013 15:54:43 -0800
X-Google-Sender-Auth: nV2Iwp6oOGRdVAjjn3SZGt3Fcxg
Message-ID: <CA+55aFyp2HnMATV1v81QwZFqXcyca-RTD93=55ba37kF4ANfCw@mail.gmail.com>
Subject: Re: [GIT] Security subsystem updates for 3.13
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Morris <jmorris@namei.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 3:30 PM, James Morris <jmorris@namei.org> wrote:
> On Mon, 18 Nov 2013, Josh Boyer wrote:
>>
>> Unless I'm missing something, I don't think this has landed in Linus'
>> tree yet.  Linus, did this pull request get NAKed or fall through the
>> cracks?
>
> I think Linus is on vacation and merging only sporadically at the moment.

No,while it is true that I've been traveling, I've also been actively
merging, and no, that pull request isn't lost.

I don't really like the look of it though (particularly all the magic
new keys changes), so I've been delaying it and merging other regular
stuff that I don't have any issues with. I'm leaving that pull for
later in order to go over it more carefully when I'm not doing fifteen
other pulls the same day..

If somebody wants to explain about the rationale new keys code, that might help.

             Linus
