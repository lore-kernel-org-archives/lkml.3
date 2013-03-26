Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab3CZRs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:48:27 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:60236 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab3CZRsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:48:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130326162228.288994ef@laptop3>
References: <20130326162228.288994ef@laptop3>
Date: Tue, 26 Mar 2013 13:48:23 -0400
Message-ID: <CA+5PVA6s_FrJ63Sb-Kcj7JZVBc+iG9AgCT3_NyR0UVBLx+aKxw@mail.gmail.com>
Subject: Re: Git bisect problem
From: Josh Boyer <jwboyer@gmail.com>
To: Mike Keehan <mike@keehan.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 12:22 PM, Mike Keehan <mike@keehan.net> wrote:
> Hi,
>
> I'm trying to find out which update causes my 5G Wifi
> connection to time out when authenticating.
>
> Following the instructions in git help bisect, I
> git cloned the kernel, then git bisect start, and
> git bisect bad v3.9.0-rc2.
>
> This errors with :-
>   fatal: Needed a single revision
>   Bad rev input: v3.9.0-rc2
>
> and git bisect good v3.9.0-rc1 gives same error.
>
> How are you supposed to specify the revision?

It has to match a tag name if you're doing that.  So it would be:

git bisect good v3.9-rc1; git bisect bad v3.9-rc2

Note the lack of .0.

josh
