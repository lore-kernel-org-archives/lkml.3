Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbaCMGWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 02:22:47 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:53931 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaCMGWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 02:22:44 -0400
MIME-Version: 1.0
In-Reply-To: <1394686919.25122.2.camel@x230>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	<CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
	<alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>
	<1394686919.25122.2.camel@x230>
Date: Wed, 12 Mar 2014 23:22:43 -0700
X-Google-Sender-Auth: ZQ8XwKntgiOnU7T1zKhMocOMc0w
Message-ID: <CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "jmorris@namei.org" <jmorris@namei.org>,
        "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        Matthew Garrett <matthew.garrett@nebula.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 10:01 PM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> On Fri, 2014-02-28 at 14:03 +1100, James Morris wrote:
>
>> Ok, which tree should take this?  I'm happy to, although most of it is
>> outside security/ .
>
> Should I be looking for someone else to take them instead? :)

Andrew, is this series[1] something you'd be okay taking? It touches
many different areas, so you might be best for it.

-Kees

[1] https://lkml.org/lkml/2014/2/26/811

-- 
Kees Cook
Chrome OS Security
