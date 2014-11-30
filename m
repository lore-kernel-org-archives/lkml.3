Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbaK3JIe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 04:08:34 -0500
Received: from albireo.enyo.de ([46.237.207.196]:44396 "EHLO albireo.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbaK3JI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 04:08:29 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Herrmann <dh.herrmann@gmail.com>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        criu@openvz.org, Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [RFC PATCH] proc, pidns: Add highpid
References: <b0f6c4df0e8ef8afcc7b786edecb4be8c752941e.1417215468.git.luto@amacapital.net>
Date: Sun, 30 Nov 2014 09:47:50 +0100
In-Reply-To: <b0f6c4df0e8ef8afcc7b786edecb4be8c752941e.1417215468.git.luto@amacapital.net>
	(Andy Lutomirski's message of "Fri, 28 Nov 2014 15:05:01 -0800")
Message-ID: <87k32d13d5.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andy Lutomirski:

> The initial implementation is straightforward: highpid is simply a
> 64-bit counter. If a high-end system can fork every 3 ns (which
> would be amazing, given that just allocating a pid requires at
> atomic operation), it would take well over 1000 years for highpid to
> wrap.

I'm not sure if I'm reading the patch correctly, but is the counter
namespaced?  If yes, why?
