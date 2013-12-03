Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab3LCPXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:23:25 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:50389 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753596Ab3LCPXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:23:23 -0500
Date: Tue, 3 Dec 2013 10:23:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Namhyung Kim <namhyung@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Arjan van de Ven <arjan@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC] Packaging libtraceevent.so
Message-ID: <20131203102321.39936e60@gandalf.local.home>
In-Reply-To: <CA+5PVA7YYhxcfnJ3NpGU6kZo-iJKHJ7NvnSp+3WL75wKq929GA@mail.gmail.com>
References: <20131202140322.4ad6a151@gandalf.local.home>
	<87txeqmpzp.fsf@sejong.aot.lge.com>
	<CA+5PVA7YYhxcfnJ3NpGU6kZo-iJKHJ7NvnSp+3WL75wKq929GA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Dec 2013 08:56:33 -0500
Josh Boyer <jwboyer@fedoraproject.org> wrote:


> So the level of stable I think would be needed is basically being able
> to ship a new libtraceevent.so and have it not break a powertop that
> was linked against a previous version.  E.g. libtraceevent.so provided
> with the 3.15 kernel release can be used as an update to the
> libtraceevent.so from the 3.13 release and powertop doesn't need to be
> rebuilt.
> 
> That's typically done with soname and/or symbol versioning.  Clearly
> applications wishing to use new libtraceevent features would need to
> be rebuilt to take advantage of those, but basic functionality should
> be pretty stable.  Changing soname/ABI happens elsewhere in userspace
> libs and isn't a big deal for development, but those bumps typically
> aren't done in the middle of a released distro version.  There are
> several distros that do major kernel version updates during the
> lifetime of a release so anything coming from those needs to be
> handled carefully.

There's a couple of things that need to be cleaned up first, that will
affect current users. But they are minor. I think we can work on this
soon and get something out by the next release.

-- Steve
