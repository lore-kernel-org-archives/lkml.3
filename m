Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab3EKJQy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 05:16:54 -0400
Received: from blu0-omc3-s18.blu0.hotmail.com ([65.55.116.93]:39246 "EHLO
	blu0-omc3-s18.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754015Ab3EKJQo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 05:16:44 -0400
X-EIP: [Ol2nAbxoh80ThQg9XcEcmMcdJJG3bJ1l]
X-Originating-Email: [yuhongbao_386@hotmail.com]
Message-ID: <BLU177-W475A0F6393620E8B6BB671C3A60@phx.gbl>
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        "Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "sonnyrao@chromium.org" <sonnyrao@chromium.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fu>
Subject: RE: [PATCH] mm,x86: limit 32 bit kernel to 12GB memory
Date: Sat, 11 May 2013 02:16:43 -0700
Importance: Normal
In-Reply-To: <CA+55aFwApXJzJYPg40Bn_+qmv470OnfwMwNMQnfV8eXKtqVzWQ@mail.gmail.com>
References: <517B1153.8000401@valvesoftware.com> <517B2FB4.30605@redhat.com>
 <20130427024248.GA1229@cmpxchg.org> <517EEBD1.503@valvesoftware.com>
 <CA+55aFxcq44JsrrR5KKuT=DZQHCfOE3KHQrcD215T+deYesW2g@mail.gmail.com>
 <517F14D1.3070307@redhat.com>
 <20130502013426.GC958,<CA+55aFwApXJzJYPg40Bn_+qmv470OnfwMwNMQnfV8eXKtqVzWQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 11 May 2013 09:16:43.0478 (UTC) FILETIME=[40E5BF60:01CE4E28]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  - I don't think it's necessarily "system stability". The problem with
> large amounts of highmem ends up being that we end up using up almost
> all of the lowmem just to *track* the huge amount of highmem, and then
> we have so little lowmem that we suck at performance and have various
> random problems. So it's not just "system stability", it's more fluid
> than that.

FYI 32-bit Windows already limits to 16GB when 3G/1G split is used for a similar reason. (They default to 2G/2G split.)

Yuhong Bao 		 	   		  