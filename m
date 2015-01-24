Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbbAXQjr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 11:39:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbbAXQjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 11:39:44 -0500
Date: Sat, 24 Jan 2015 17:39:25 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: =?iso-8859-1?Q?J=E9r=E9mie?= Galarneau 
	<jeremie.galarneau@efficios.com>
Cc: Wang Nan <wangnan0@huawei.com>, Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Li Zefan <lizefan@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] perf: convert: fix duplicate field names and
 avoid reserved keywords.
Message-ID: <20150124163925.GD17627@krava.brq.redhat.com>
References: <1421904958-24106-1-git-send-email-wangnan0@huawei.com>
 <1421905003-24242-1-git-send-email-wangnan0@huawei.com>
 <20150122132734.GB2473@krava.brq.redhat.com>
 <54C1AAA1.4000300@huawei.com>
 <CA+jJMxsjh=H+f3z+cnJ6tFbmyrD-ArGSe7agVVvc4tird8MdHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+jJMxsjh=H+f3z+cnJ6tFbmyrD-ArGSe7agVVvc4tird8MdHw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 05:40:02PM -0500, Jérémie Galarneau wrote:

SNIP

> > bt_ctf_clock_create() with the checked name and then free it. However, it is hacky
> > and I think you won't like it.
> 
> The prospect of seeing that code has convinced me to introduce
> int bt_ctf_validate_identifier(const char *identifier);
> 
> commit 654c1444b546fd79b209288b93ed4e87d9bb8a2b
> Author: Jérémie Galarneau <jeremie.galarneau@efficios.com>
> Date:   Fri Jan 23 16:24:52 2015 -0500
> 
>     Add utility function to validate CTF identifiers
> 
>     Introduces bt_ctf_validate_identifier() which validates a given
>     identifier against the list of CTF reserved keywords.
> 
>     This function may evolve to perform additional validity checks in
>     the future as the CTF specification moves forward.
> 
>     Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>     Signed-off-by: Jérémie Galarneau <jeremie.galarneau@efficios.com>
> 
> 
> Does that take care of the problem?

seems good to me, thanks

jirka
