Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783Ab3IASLo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 14:11:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22929 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab3IASLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 14:11:42 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=_W9BnI6ACgIA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=4fJcwidASCIA:10 a=Z4Rwk6OoAAAA:8 a=l9HRZPxBAAAA:8 a=ZVv3pjlE3SzYggNwVvsA:9 a=CjuIK1q_8ugA:10 a=jbrJJM5MRmoA:10 a=w_bq7eTU9_QA:10 a=DweY73hz9PUA:10 a=f4TapD6NL_kA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Sun, 1 Sep 2013 14:11:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, George Spelvin <linux@horizon.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Waiman Long <waiman.long@hp.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
Message-ID: <20130901141139.43645159@gandalf.local.home>
In-Reply-To: <CA+55aFx5oAdGHGXd9P95-0UrKe9Tki_8Q8NoUtCVJtM-=he-Cg@mail.gmail.com>
References: <CA+55aFz7k5zUvJdZxpZgCgfx_-PT+f-9J50hnC1i3x=8_dXkBw@mail.gmail.com>
	<20130901085049.21748.qmail@science.horizon.com>
	<20130901111008.GA28812@thunk.org>
	<CA+55aFx5oAdGHGXd9P95-0UrKe9Tki_8Q8NoUtCVJtM-=he-Cg@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Sep 2013 08:49:48 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:


> Nobody used to care, because we used to not use that broken type in the kernel.

I've been told that gcc works better with 'bool' than with an int.
Should I replace those bools with bit fields in the structure?

-- Steve
