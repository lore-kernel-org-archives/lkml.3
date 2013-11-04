Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab3KDHAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 02:00:41 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:43242 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab3KDHAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 02:00:39 -0500
MIME-Version: 1.0
In-Reply-To: <52749663.2000701@cn.fujitsu.com>
References: <878uzmhkqg.fsf@xmission.com>
	<52749663.2000701@cn.fujitsu.com>
Date: Mon, 4 Nov 2013 09:00:39 +0200
Message-ID: <CAE=NcrY+CzX+H4XQTdGj7CSZ98a5T=bNgT6=jGZzcjyaHb-ttw@mail.gmail.com>
Subject: Re: [REVIEW][PATCH 1/2] userns: Better restrictions on when proc and
 sysfs can be mounted
From: Janne Karhunen <janne.karhunen@gmail.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 2, 2013 at 8:06 AM, Gao feng <gaofeng@cn.fujitsu.com> wrote:

> And another question, it looks like if we don't have proc/sys fs mounted,
> then proc/sys will be failed to be mounted?

I have been wondering the same. Was quite some illogical surprise that
we have to be doing overlay mounts. This is the exact opposite from what
anyone would expect.


-- 
Janne
