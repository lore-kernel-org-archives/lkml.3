Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab3C2SKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 14:10:14 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:49306 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996Ab3C2SKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 14:10:11 -0400
MIME-Version: 1.0
In-Reply-To: <20130329180455.GA22395@redhat.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
	<20130326192852.GA25899@redhat.com>
	<20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
	<20130329161746.GA8391@redhat.com>
	<CA+55aFxbs0=fpFA+rAW-jOD9C8muRfA0otfJ13yhhLMSg7H8bw@mail.gmail.com>
	<20130329180455.GA22395@redhat.com>
Date: Fri, 29 Mar 2013 11:10:11 -0700
X-Google-Sender-Auth: us7sPs-TWp0w3WyRbm7Y9Tm6saw
Message-ID: <CA+55aFzkyV7xReBSjxisftPdAMOQVxO1ahbOT45Y+cjTyyq0XA@mail.gmail.com>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Peter Hurley <peter@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 11:04 AM, Dave Jones <davej@redhat.com> wrote:
>
> mainline. Your current tree.

Ok, that's what I thought you were generally testing, just wanted to
verify. The subject kind of implied otherwise..

          Linus
