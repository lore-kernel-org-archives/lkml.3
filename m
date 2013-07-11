Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab3GKAmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 20:42:43 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:44125 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab3GKAml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 20:42:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130710235636.GA2879@redhat.com>
References: <1373497956-8770-1-git-send-email-taysom@chromium.org>
	<20130710235636.GA2879@redhat.com>
Date: Wed, 10 Jul 2013 17:42:40 -0700
Message-ID: <CAKwO_5EhHaJs23+Y6EiwrXaBUPj=MBGHuQ+E2nUyMYphBBGpJQ@mail.gmail.com>
Subject: Re: [PATCH] fs: sync: fixed performance regression
From: Paul Taysom <taysom@google.com>
To: Dave Jones <davej@redhat.com>, Paul Taysom <taysom@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        jack@suse.cz, sonnyrao@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 4:56 PM, Dave Jones <davej@redhat.com> wrote:
> On Wed, Jul 10, 2013 at 04:12:36PM -0700, Paul Taysom wrote:
>
>  > Note, when running the test, the slow down doesn't always happen
>  > but most of the tests will show a slow down.
>  >
>  > In response to crbug.com/240422
>
> Just in case this ends up as the actual commit msg, that url
> seems to be the wrong bug.
>
>         Dave.

Copied the wrong number crbug.con/218910
Thanks.
