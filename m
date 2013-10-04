Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab3JDRAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:00:23 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:41823 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3JDRAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:00:22 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20131004143440.GO27287@sirena.org.uk>
References: <20131004010230.GI27287@sirena.org.uk>
	<524E50DB.3060707@roeck-us.net>
	<CAOesGMhc5WYRFcBVSHShg6h8hn4HueGZtGCFKkzfX4SQEe_5LQ@mail.gmail.com>
	<524EC658.90706@roeck-us.net>
	<20131004143440.GO27287@sirena.org.uk>
Date: Fri, 4 Oct 2013 10:00:20 -0700
Message-ID: <CAOesGMhrF+RB9O2f1JGtkT02amZQCx1nUo0GjmeBErYiSHSVZA@mail.gmail.com>
Subject: Re: linux-next: Tree for Oct 3
From: Olof Johansson <olof@lixom.net>
To: Mark Brown <broonie@kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 4, 2013 at 7:34 AM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Oct 04, 2013 at 06:44:56AM -0700, Guenter Roeck wrote:
>
>> Great summaries. Do you have a single builder, or several builders and
>> collect the results ? Either case, any chance sharing the buildbot scripts ?
>
> There's a repo at:
>
>   git://git.linaro.org/people/khilman/build-scripts.git

A git url is frustrating, especially when the gitweb isn't configured
to use the same paths.

https://git.linaro.org/gitweb?p=people/khilman/build-scripts.git;a=summary

> (Olof and Kevin have been collaborating on them).

What I use is quite different from that, but the origins are more or
less the same.


-Olof
