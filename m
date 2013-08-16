Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab3HPHWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 03:22:23 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:38638 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab3HPHWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 03:22:21 -0400
MIME-Version: 1.0
In-Reply-To: <20130816054823.GB28445@thor.bakeyournoodle.com>
References: <520C9A39.3030808@roeck-us.net>
	<CAMo8BfKyqZYMkh96wyZSpYUpXwqFQZkco=XgtjUrNG-jSzW5pA@mail.gmail.com>
	<20130816054823.GB28445@thor.bakeyournoodle.com>
Date: Fri, 16 Aug 2013 11:22:21 +0400
Message-ID: <CAMo8Bf+veq_DU7-hnB0yySy6YWpwU2TYx3U9e89c_m8Mv9Cv5w@mail.gmail.com>
Subject: Re: Linux kernel cross-compilers
From: Max Filippov <jcmvbkbc@gmail.com>
To: Max Filippov <jcmvbkbc@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 9:48 AM, Tony Breeds <tony@bakeyournoodle.com> wrote:
> On Thu, Aug 15, 2013 at 01:46:16PM +0400, Max Filippov wrote:
>
>> Yes, xtensa compiler/linker is known to have issues with link-time
>> relaxation; e.g. it may fail to build linux image without CONFIG_LD_NO_RELAX.
>
> Is there something I can do at linker build time to help with this?

I don't think so. Apparently it's not a linker configuration issue, it's a bug.
-- 
Thanks.
-- Max
