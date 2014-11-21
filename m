Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaKUVIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 16:08:39 -0500
Received: from mail.rmail.be ([85.234.218.189]:60782 "EHLO mail.rmail.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbaKUVIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 16:08:38 -0500
Message-ID: <2922e9932862ff847052dabae293c4e0.squirrel@mail.rmail.be>
In-Reply-To: <20141121200622.GB26833@amd>
References: <8bdeb6866adef7f2d34a693040c33f12.squirrel@mail.rmail.be>
    <20141121200622.GB26833@amd>
Date: Fri, 21 Nov 2014 21:08:37 -0000
Subject: Re: Memory leaks on atom-based boards?
From: "AL13N" <alien@rmail.be>
To: linux-kernel@vger.kernel.org
Cc: "Pavel Machek" <pavel@ucw.cz>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

err

the whole point is that swap stays largely unused and get OOM after 3 or 4
days on only atom boards (2), while the other machines(5) with the
identical kernel are unaffected by this and can run for several months...

plus, upgrade to 3.17.2 seems to have fixed the issue...

it's categorized as a slow and steady decline in MemAvailable in
/proc/meminfo.

i can report that the server in question is now running since i fixed it,
several weeks now, and MemAvailable is still above 3GB ...

