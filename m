Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab3COWAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 18:00:34 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:41630 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab3COWAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 18:00:32 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F792736C4@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F7927366E@DQHE02.ent.ti.com>
 <20130220090723.GA8049@balto.lan> <A874F61F95741C4A9BA573A70FE3998F792736C4@DQHE02.ent.ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Fri, 15 Mar 2013 15:00:10 -0700
Message-ID: <CAK5ve-KmkhtgzLDn3jCgi1vyDb1oXCf6oj-pxDdr9hurS+vhAw@mail.gmail.com>
Subject: Re: [PATCH 1/3] leds: move LED trigger drivers into new subdirectory
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Fabio Baltieri <fabio.baltieri@linaro.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeong, Daniel" <Daniel.Jeong@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 1:29 AM, Kim, Milo <Milo.Kim@ti.com> wrote:
>> For this kind of patches you should really use the "-M" flag of "git
>> format-patch" to activate rename detection.  The patch becomes much
>> more
>> readable.  For example, the diffstat for this one using -M is:
>
> Thanks for useful tip!
>

Instead put -M every time run format-patch, run this command should be helpful:

git config --global diff.renames true

Thanks Arnd Bergmann and Stephen Warren
-Bryan
